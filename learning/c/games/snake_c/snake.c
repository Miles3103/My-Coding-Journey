#include <SDL2/SDL.h>
#include <SDL2/SDL_mixer.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <string.h>
#include <math.h>

/* ── Config ──────────────────────────────────────────────────── */
#define CELL        20       /* pixel size of one grid cell       */
#define COLS        30       /* grid columns  (800 / 20 = 40... using 30 for padding) */
#define ROWS        28       /* grid rows                         */
#define WIN_W       (COLS * CELL + 2 * MARGIN)
#define WIN_H       (ROWS * CELL + HUD + 2 * MARGIN)
#define HUD         40       /* top bar height                    */
#define MARGIN      10       /* border around grid                */
#define INIT_LEN    4        /* starting snake length             */
#define FPS_INIT    8        /* starting game speed               */
#define FPS_MAX     20       /* max speed                         */
#define MAX_LIVES   3        /* lives per game                    */

/* ── Colors ──────────────────────────────────────────────────── */
#define COL_BG       0x0D, 0x11, 0x17   /* near-black            */
#define COL_GRID     0x16, 0x1B, 0x22   /* subtle grid lines     */
#define COL_SNAKE_H  0x3F, 0xB9, 0x50   /* head: bright green    */
#define COL_SNAKE_B  0x23, 0x6E, 0x2E   /* body: darker green    */
#define COL_FOOD     0xF8, 0x51, 0x49   /* red apple             */
#define COL_WALL     0x30, 0x36, 0x3D   /* wall border           */
#define COL_TEXT     0xE6, 0xED, 0xF3   /* white text            */
#define COL_DIM      0x8B, 0x94, 0x9E   /* muted text            */
#define COL_SCORE    0x79, 0xC0, 0xFF   /* blue score            */
#define COL_OVER_BG  0x00, 0x00, 0x00   /* game over overlay     */

/* ── Audio ───────────────────────────────────────────────────── */
#define SAMPLE_RATE  44100
#define AUDIO_CHANS  2      /* stereo                            */
#define CHUNK_SIZE   512

/* sound handles */
static Mix_Chunk *snd_eat      = NULL;
static Mix_Chunk *snd_crash    = NULL;
static Mix_Chunk *snd_gameover = NULL;
static Mix_Chunk *snd_levelup  = NULL;

/* ── Sound synthesis helpers ─────────────────────────────────── */
/* Build a Mix_Chunk from a raw PCM buffer (stereo Sint16) */
static Mix_Chunk *make_chunk(Sint16 *buf, int samples) {
    int bytes = samples * AUDIO_CHANS * sizeof(Sint16);
    Uint8 *data = (Uint8 *)malloc(bytes);
    if (!data) { return NULL; }
    memcpy(data, buf, bytes);
    Mix_Chunk *c = (Mix_Chunk *)calloc(1, sizeof(Mix_Chunk));
    if (!c) { free(data); return NULL; }
    c->allocated = 1;
    c->abuf      = data;
    c->alen      = bytes;
    c->volume    = MIX_MAX_VOLUME;
    return c;
}

/* sine wave, freq Hz, dur_ms, volume 0-1, optional pitch slide */
static Mix_Chunk *synth_tone(float freq, int dur_ms, float vol,
                              float freq_end) {
    int samples = SAMPLE_RATE * dur_ms / 1000;
    Sint16 *buf = (Sint16 *)malloc(samples * AUDIO_CHANS * sizeof(Sint16));
    if (!buf) { return NULL; }
    for (int i = 0; i < samples; i++) {
        float t    = (float)i / SAMPLE_RATE;
        float frac = (float)i / samples;
        float f    = freq + (freq_end - freq) * frac;
        /* envelope: quick attack, smooth decay */
        float env  = (i < 100 ? (float)i / 100.f : 1.f - frac * 0.8f);
        float v    = sinf(2.f * 3.14159f * f * t) * vol * env * 32767.f;
        Sint16 s   = (Sint16)v;
        buf[i * 2]     = s;
        buf[i * 2 + 1] = s;
    }
    Mix_Chunk *c = make_chunk(buf, samples);
    free(buf);
    return c;
}

/* noise burst — for crash/explosion */
static Mix_Chunk *synth_noise(int dur_ms, float vol) {
    int samples = SAMPLE_RATE * dur_ms / 1000;
    Sint16 *buf = (Sint16 *)malloc(samples * AUDIO_CHANS * sizeof(Sint16));
    if (!buf) { return NULL; }
    for (int i = 0; i < samples; i++) {
        float frac = (float)i / samples;
        float env  = (1.f - frac) * (1.f - frac);  /* fast decay */
        /* noise + low rumble */
        float noise  = ((float)rand() / RAND_MAX * 2.f - 1.f);
        float rumble = sinf(2.f * 3.14159f * 80.f * (float)i / SAMPLE_RATE);
        float v = (noise * 0.7f + rumble * 0.3f) * vol * env * 32767.f;
        Sint16 s = (Sint16)v;
        buf[i * 2]     = s;
        buf[i * 2 + 1] = s;
    }
    Mix_Chunk *c = make_chunk(buf, samples);
    free(buf);
    return c;
}

/* sequence of tones for melodies */
typedef struct { float freq; int dur_ms; } Note;

static Mix_Chunk *synth_melody(const Note *notes, int n, float vol) {
    /* calculate total samples */
    int total = 0;
    for (int i = 0; i < n; i++) { total += SAMPLE_RATE * notes[i].dur_ms / 1000; }
    Sint16 *buf = (Sint16 *)calloc(total * AUDIO_CHANS, sizeof(Sint16));
    if (!buf) { return NULL; }
    int offset = 0;
    for (int i = 0; i < n; i++) {
        int samp = SAMPLE_RATE * notes[i].dur_ms / 1000;
        for (int j = 0; j < samp; j++) {
            float frac = (float)j / samp;
            float env  = (j < 50 ? (float)j / 50.f : 1.f - frac * 0.6f);
            float v    = sinf(2.f * 3.14159f * notes[i].freq * (float)j / SAMPLE_RATE)
                         * vol * env * 32767.f;
            Sint16 s = (Sint16)v;
            buf[(offset + j) * 2]     = s;
            buf[(offset + j) * 2 + 1] = s;
        }
        offset += samp;
    }
    Mix_Chunk *c = make_chunk(buf, total);
    free(buf);
    return c;
}

/* ── Audio init ──────────────────────────────────────────────── */
static Mix_Chunk *bgm_chunk = NULL;

static void audio_init(void) {
    if (Mix_OpenAudio(SAMPLE_RATE, AUDIO_S16SYS, AUDIO_CHANS, CHUNK_SIZE) < 0) {
        fprintf(stderr, "Mix_OpenAudio: %s\n", Mix_GetError());
        return;
    }
    Mix_AllocateChannels(8);

    /* eat: quick upward chirp */
    snd_eat = synth_tone(600.f, 80, 0.4f, 900.f);

    /* crash: noise burst + low drop */
    snd_crash = synth_noise(300, 0.6f);

    /* level up: happy 3-note arpeggio */
    Note lvl[] = { {523.f,80}, {659.f,80}, {784.f,140} };
    snd_levelup = synth_melody(lvl, 3, 0.5f);

    /* game over: sad descending melody */
    Note over[] = { {392.f,150}, {349.f,150}, {330.f,150},
                    {294.f,150}, {261.f,300} };
    snd_gameover = synth_melody(over, 5, 0.5f);

    /* bgm: looping arpeggio as chunk on channel 0 */
    float bnotes[] = { 261.6f,329.6f,392.0f,523.3f,392.0f,329.6f,261.6f,196.0f };
    int   bnote_c  = 8;
    int   note_ms  = 140;
    int   loops    = 8;
    int   spn      = SAMPLE_RATE * note_ms / 1000;
    int   total    = bnote_c * loops * spn;
    Sint16 *bbuf   = (Sint16 *)calloc(total * AUDIO_CHANS, sizeof(Sint16));
    if (bbuf) {
        for (int rep = 0; rep < loops; rep++) {
            for (int ni = 0; ni < bnote_c; ni++) {
                int base = (rep * bnote_c + ni) * spn;
                float freq = bnotes[ni];
                for (int j = 0; j < spn; j++) {
                    float frac = (float)j / spn;
                    float env  = (j < 30 ? (float)j/30.f : 1.f - frac*0.4f);
                    float v = (sinf(2.f*3.14159f*freq*(float)j/SAMPLE_RATE)*0.6f
                              +sinf(2.f*3.14159f*freq*2.f*(float)j/SAMPLE_RATE)*0.15f)
                              * 0.28f * env * 32767.f;
                    Sint16 s = (Sint16)v;
                    bbuf[(base+j)*2]   = s;
                    bbuf[(base+j)*2+1] = s;
                }
            }
        }
        bgm_chunk = make_chunk(bbuf, total);
        free(bbuf);
    }

    /* start bgm looping on channel 0 */
    if (bgm_chunk) { Mix_PlayChannel(0, bgm_chunk, -1); }
    Mix_Volume(0, 40); /* bgm quieter than sfx */
}

static void audio_free(void) {
    Mix_HaltChannel(-1);
    if (snd_eat)      { Mix_FreeChunk(snd_eat);      snd_eat      = NULL; }
    if (snd_crash)    { Mix_FreeChunk(snd_crash);    snd_crash    = NULL; }
    if (snd_levelup)  { Mix_FreeChunk(snd_levelup);  snd_levelup  = NULL; }
    if (snd_gameover) { Mix_FreeChunk(snd_gameover); snd_gameover = NULL; }
    if (bgm_chunk)    { Mix_FreeChunk(bgm_chunk);    bgm_chunk    = NULL; }
    Mix_CloseAudio();
}

/* ── Types ───────────────────────────────────────────────────── */
typedef struct { int x, y; } Vec2;

typedef enum { DIR_UP, DIR_DOWN, DIR_LEFT, DIR_RIGHT } Dir;

typedef struct {
    Vec2  body[COLS * ROWS];   /* ring buffer of segments          */
    int   head;                /* index of head in buffer          */
    int   len;                 /* current length                   */
    Dir   dir;                 /* current direction                */
    Dir   next_dir;            /* buffered next direction          */
} Snake;

typedef enum { STATE_PLAY, STATE_OVER, STATE_PAUSE, STATE_LIFE_LOST } State;

/* ── Globals ─────────────────────────────────────────────────── */
static Snake  snake;
static Vec2   food;
static int    score      = 0;
static int    high_score = 0;
static int    lives      = MAX_LIVES;
static State  state      = STATE_PLAY;
static int    speed      = FPS_INIT;
static Uint32 life_lost_timer = 0;  /* timestamp when life was lost */

/* ── Helpers ─────────────────────────────────────────────────── */
static void set_color(SDL_Renderer *r, Uint8 R, Uint8 G, Uint8 B, Uint8 A) {
    SDL_SetRenderDrawColor(r, R, G, B, A);
}

static SDL_Rect cell_rect(int x, int y) {
    return (SDL_Rect){
        MARGIN + x * CELL + 1,
        HUD + MARGIN + y * CELL + 1,
        CELL - 2,
        CELL - 2
    };
}

/* ── Food ────────────────────────────────────────────────────── */
static int on_snake(Vec2 pos) {
    for (int i = 0; i < snake.len; i++) {
        int idx = (snake.head - i + COLS * ROWS) % (COLS * ROWS);
        if (snake.body[idx].x == pos.x && snake.body[idx].y == pos.y)
            return 1;
    }
    return 0;
}

static void spawn_food(void) {
    Vec2 f;
    do {
        f.x = rand() % COLS;
        f.y = rand() % ROWS;
    } while (on_snake(f));
    food = f;
}

/* ── Snake init ──────────────────────────────────────────────── */
static void snake_init(void) {
    memset(&snake, 0, sizeof(snake));
    snake.len      = INIT_LEN;
    snake.head     = INIT_LEN - 1;
    snake.dir      = DIR_RIGHT;
    snake.next_dir = DIR_RIGHT;
    for (int i = 0; i < INIT_LEN; i++) {
        snake.body[i].x = i;
        snake.body[i].y = ROWS / 2;
    }
}

/* ── Game reset (full new game) ──────────────────────────────── */
static void game_reset(void) {
    if (score > high_score) { high_score = score; }
    score = 0;
    speed = FPS_INIT;
    lives = MAX_LIVES;
    snake_init();
    spawn_food();
    state = STATE_PLAY;
    /* restart bgm */
    Mix_HaltChannel(0);
    if (bgm_chunk) { Mix_PlayChannel(0, bgm_chunk, -1); Mix_Volume(0, 40); }
}

/* ── Life lost — respawn snake, keep score & lives ───────────── */
static void life_lost(void) {
    if (snd_crash) { Mix_PlayChannel(1, snd_crash, 0); }
    lives--;
    if (lives <= 0) {
        if (snd_gameover) { Mix_PlayChannel(2, snd_gameover, 0); }
        Mix_HaltChannel(0); /* stop bgm on game over */
        state = STATE_OVER;
    } else {
        state = STATE_LIFE_LOST;
        life_lost_timer = SDL_GetTicks();
        snake_init();
        spawn_food();
    }
}

/* ── Move ────────────────────────────────────────────────────── */
static void snake_move(void) {
    snake.dir = snake.next_dir;

    Vec2 head = snake.body[snake.head];
    Vec2 next = head;

    switch (snake.dir) {
        case DIR_UP:    next.y--; break;
        case DIR_DOWN:  next.y++; break;
        case DIR_LEFT:  next.x--; break;
        case DIR_RIGHT: next.x++; break;
    }

    /* wall collision */
    if (next.x < 0 || next.x >= COLS || next.y < 0 || next.y >= ROWS) {
        life_lost();
        return;
    }

    /* self collision (skip tail tip — it will move) */
    for (int i = 0; i < snake.len - 1; i++) {
        int idx = (snake.head - i + COLS * ROWS) % (COLS * ROWS);
        if (snake.body[idx].x == next.x && snake.body[idx].y == next.y) {
            life_lost();
            return;
        }
    }

    /* advance head */
    snake.head = (snake.head + 1) % (COLS * ROWS);
    snake.body[snake.head] = next;

    /* eat food */
    if (next.x == food.x && next.y == food.y) {
        snake.len++;
        score++;
        /* speed up every 5 points */
        if (score % 5 == 0 && speed < FPS_MAX) {
            speed++;
            if (snd_levelup) { Mix_PlayChannel(3, snd_levelup, 0); }
        } else {
            if (snd_eat) { Mix_PlayChannel(4, snd_eat, 0); }
        }
        spawn_food();
    }
}

/* ── Draw grid ───────────────────────────────────────────────── */
static void draw_grid(SDL_Renderer *r) {
    set_color(r, COL_GRID, 255);
    for (int x = 0; x <= COLS; x++) {
        int px = MARGIN + x * CELL;
        SDL_RenderDrawLine(r, px, HUD + MARGIN, px, HUD + MARGIN + ROWS * CELL);
    }
    for (int y = 0; y <= ROWS; y++) {
        int py = HUD + MARGIN + y * CELL;
        SDL_RenderDrawLine(r, MARGIN, py, MARGIN + COLS * CELL, py);
    }
}

/* ── Draw snake ──────────────────────────────────────────────── */
static void draw_snake(SDL_Renderer *r) {
    for (int i = 0; i < snake.len; i++) {
        int idx = (snake.head - i + COLS * ROWS) % (COLS * ROWS);
        SDL_Rect rc = cell_rect(snake.body[idx].x, snake.body[idx].y);

        if (i == 0) {
            /* head */
            set_color(r, COL_SNAKE_H, 255);
            SDL_RenderFillRect(r, &rc);
            /* eyes */
            set_color(r, 0x0D, 0x11, 0x17, 255);
            int ex = rc.x + rc.w / 2;
            int ey = rc.y + rc.h / 2;
            switch (snake.dir) {
                case DIR_RIGHT: { SDL_Rect e1={rc.x+rc.w-5, ey-4,3,3}; SDL_Rect e2={rc.x+rc.w-5, ey+2,3,3}; SDL_RenderFillRect(r,&e1); SDL_RenderFillRect(r,&e2); break; }
                case DIR_LEFT:  { SDL_Rect e1={rc.x+2, ey-4,3,3};      SDL_Rect e2={rc.x+2, ey+2,3,3};      SDL_RenderFillRect(r,&e1); SDL_RenderFillRect(r,&e2); break; }
                case DIR_UP:    { SDL_Rect e1={ex-4, rc.y+2,3,3};      SDL_Rect e2={ex+2, rc.y+2,3,3};      SDL_RenderFillRect(r,&e1); SDL_RenderFillRect(r,&e2); break; }
                case DIR_DOWN:  { SDL_Rect e1={ex-4, rc.y+rc.h-5,3,3}; SDL_Rect e2={ex+2, rc.y+rc.h-5,3,3}; SDL_RenderFillRect(r,&e1); SDL_RenderFillRect(r,&e2); break; }
            }
        } else {
            /* body — slightly rounded feel via inset */
            Uint8 fade = (Uint8)(0x23 + (i * 4 > 0x1A ? 0 : i * 4));
            set_color(r, fade, 0x6E, 0x2E, 255);
            SDL_RenderFillRect(r, &rc);
        }
    }
}

/* ── Draw food ───────────────────────────────────────────────── */
static void draw_food(SDL_Renderer *r) {
    SDL_Rect rc = cell_rect(food.x, food.y);
    set_color(r, COL_FOOD, 255);
    SDL_RenderFillRect(r, &rc);
    /* shine dot */
    set_color(r, 0xFF, 0x99, 0x95, 255);
    SDL_Rect shine = { rc.x + 3, rc.y + 3, 3, 3 };
    SDL_RenderFillRect(r, &shine);
}

/* ── Draw hearts (lives) ─────────────────────────────────────── */
static void draw_hearts(SDL_Renderer *r) {
    for (int i = 0; i < MAX_LIVES; i++) {
        int hx = WIN_W - MARGIN - (MAX_LIVES - i) * 22;
        int hy = 10;
        int hw = 16, hh = 14;
        if (i < lives) {
            set_color(r, 0xF8, 0x51, 0x49, 255); /* red — full */
        } else {
            set_color(r, 0x30, 0x36, 0x3D, 255); /* gray — lost */
        }
        /* simple heart: two squares + diamond */
        SDL_Rect left  = { hx,        hy,     hw/2, hh/2 };
        SDL_Rect right = { hx + hw/2, hy,     hw/2, hh/2 };
        SDL_Rect body  = { hx,        hy + 4, hw,   hh/2 };
        SDL_RenderFillRect(r, &left);
        SDL_RenderFillRect(r, &right);
        SDL_RenderFillRect(r, &body);
        /* bottom triangle point */
        for (int row = 0; row < 5; row++) {
            int pw = hw - row * 2;
            if (pw <= 0) { break; }
            SDL_Rect pt = { hx + row, hy + hh/2 + row, pw, 1 };
            SDL_RenderFillRect(r, &pt);
        }
    }
}

/* ── Draw HUD ────────────────────────────────────────────────── */
static void draw_hud(SDL_Renderer *r, SDL_Window *w) {
    char title[160];
    snprintf(title, sizeof(title),
        "Snake  |  Score: %d  |  Best: %d  |  Lives: %d  |  Speed: %d  |  P=pause  |  ESC=quit",
        score, high_score, lives, speed);
    SDL_SetWindowTitle(w, title);

    /* HUD bar */
    set_color(r, 0x16, 0x1B, 0x22, 255);
    SDL_Rect bar = { 0, 0, WIN_W, HUD };
    SDL_RenderFillRect(r, &bar);

    /* border line under HUD */
    set_color(r, COL_WALL, 255);
    SDL_RenderDrawLine(r, 0, HUD - 1, WIN_W, HUD - 1);

    draw_hearts(r);
}

/* ── Draw overlay ────────────────────────────────────────────── */
static void draw_overlay(SDL_Renderer *r) {
    /* dim background */
    SDL_SetRenderDrawBlendMode(r, SDL_BLENDMODE_BLEND);
    set_color(r, 0, 0, 0, 160);
    SDL_Rect full = { MARGIN, HUD + MARGIN, COLS * CELL, ROWS * CELL };
    SDL_RenderFillRect(r, &full);
    SDL_SetRenderDrawBlendMode(r, SDL_BLENDMODE_NONE);

    int bw = 260, bh = 90;
    int bx = (WIN_W - bw) / 2;
    int by = (WIN_H - bh) / 2;
    set_color(r, 0x16, 0x1B, 0x22, 255);
    SDL_Rect box = { bx, by, bw, bh };
    SDL_RenderFillRect(r, &box);
    set_color(r, COL_WALL, 255);
    SDL_RenderDrawRect(r, &box);

    if (state == STATE_OVER) {
        /* red X */
        set_color(r, COL_FOOD, 255);
        for (int i = 0; i < 3; i++) {
            SDL_RenderDrawLine(r, bx+20+i, by+20, bx+bw-20+i, by+bh-20);
            SDL_RenderDrawLine(r, bx+bw-20+i, by+20, bx+20+i, by+bh-20);
        }
    } else if (state == STATE_PAUSE) {
        /* blue pause bars */
        set_color(r, COL_SCORE, 255);
        SDL_Rect p1 = { bx + bw/2 - 20, by + 20, 18, bh - 40 };
        SDL_Rect p2 = { bx + bw/2 + 2,  by + 20, 18, bh - 40 };
        SDL_RenderFillRect(r, &p1);
        SDL_RenderFillRect(r, &p2);
    } else if (state == STATE_LIFE_LOST) {
        /* yellow warning — draw remaining hearts large */
        int cx = bx + bw / 2;
        int cy = by + bh / 2;
        /* draw remaining hearts centered */
        int hw = 20, hgap = 28;
        int total = MAX_LIVES * hgap;
        int sx = cx - total / 2 + 4;
        for (int i = 0; i < MAX_LIVES; i++) {
            int hx = sx + i * hgap;
            int hy = cy - hw / 2;
            if (i < lives) {
                set_color(r, 0xF8, 0x51, 0x49, 255);
            } else {
                set_color(r, 0x30, 0x36, 0x3D, 255);
            }
            SDL_Rect hl = { hx,        hy,     hw/2, hw/2 };
            SDL_Rect hr = { hx + hw/2, hy,     hw/2, hw/2 };
            SDL_Rect hb = { hx,        hy + 5, hw,   hw/2 };
            SDL_RenderFillRect(r, &hl);
            SDL_RenderFillRect(r, &hr);
            SDL_RenderFillRect(r, &hb);
            for (int row = 0; row < 6; row++) {
                int pw = hw - row * 2;
                if (pw <= 0) { break; }
                SDL_Rect pt = { hx + row, hy + hw/2 + row + 2, pw, 1 };
                SDL_RenderFillRect(r, &pt);
            }
        }
    }
}

/* ── Main ────────────────────────────────────────────────────── */
int main(void) {
    srand((unsigned)time(NULL));

    if (SDL_Init(SDL_INIT_VIDEO | SDL_INIT_AUDIO) < 0) {
        fprintf(stderr, "SDL_Init: %s\n", SDL_GetError());
        return 1;
    }

    SDL_Window *win = SDL_CreateWindow(
        "Snake",
        SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED,
        WIN_W, WIN_H,
        SDL_WINDOW_SHOWN);
    if (!win) { SDL_Quit(); return 1; }

    SDL_Renderer *ren = SDL_CreateRenderer(win, -1,
        SDL_RENDERER_ACCELERATED | SDL_RENDERER_PRESENTVSYNC);
    if (!ren) { SDL_DestroyWindow(win); SDL_Quit(); return 1; }

    audio_init();
    game_reset();

    int running    = 1;
    Uint32 last_tick = SDL_GetTicks();
    SDL_Event ev;

    while (running) {
        /* ── Events ── */
        while (SDL_PollEvent(&ev)) {
            if (ev.type == SDL_QUIT) running = 0;
            if (ev.type == SDL_KEYDOWN) {
                switch (ev.key.keysym.sym) {
                    case SDLK_ESCAPE: running = 0; break;
                    case SDLK_p:
                    case SDLK_SPACE:
                        if (state == STATE_PLAY)            { state = STATE_PAUSE; }
                        else if (state == STATE_PAUSE)       { state = STATE_PLAY; }
                        else if (state == STATE_OVER)        { game_reset(); }
                        else if (state == STATE_LIFE_LOST)   { state = STATE_PLAY; }
                        break;
                    case SDLK_RETURN:
                        if (state == STATE_OVER)             { game_reset(); }
                        else if (state == STATE_LIFE_LOST)   { state = STATE_PLAY; }
                        break;
                    /* direction — prevent 180° reversal */
                    case SDLK_UP:    case SDLK_w:
                        if (snake.dir != DIR_DOWN)  { snake.next_dir = DIR_UP; }    break;
                    case SDLK_DOWN:  case SDLK_s:
                        if (snake.dir != DIR_UP)    { snake.next_dir = DIR_DOWN; }  break;
                    case SDLK_LEFT:  case SDLK_a:
                        if (snake.dir != DIR_RIGHT) { snake.next_dir = DIR_LEFT; }  break;
                    case SDLK_RIGHT: case SDLK_d:
                        if (snake.dir != DIR_LEFT)  { snake.next_dir = DIR_RIGHT; } break;
                }
            }
        }

        /* ── Game tick ── */
        Uint32 now = SDL_GetTicks();
        Uint32 tick_ms = 1000 / speed;

        /* after life lost, auto-resume after 1.5 seconds */
        if (state == STATE_LIFE_LOST && now - life_lost_timer >= 1500) {
            state = STATE_PLAY;
        }

        if (state == STATE_PLAY && now - last_tick >= tick_ms) {
            snake_move();
            last_tick = now;
        }

        /* ── Draw ── */
        set_color(ren, COL_BG, 255);
        SDL_RenderClear(ren);

        draw_hud(ren, win);
        draw_grid(ren);
        draw_food(ren);
        draw_snake(ren);

        /* wall border */
        set_color(ren, COL_WALL, 255);
        SDL_Rect border = { MARGIN, HUD + MARGIN, COLS * CELL, ROWS * CELL };
        SDL_RenderDrawRect(ren, &border);

        if (state == STATE_OVER || state == STATE_PAUSE || state == STATE_LIFE_LOST)
            draw_overlay(ren);

        SDL_RenderPresent(ren);
        SDL_Delay(8);
    }

    audio_free();
    SDL_DestroyRenderer(ren);
    SDL_DestroyWindow(win);
    SDL_Quit();
    return 0;
}
