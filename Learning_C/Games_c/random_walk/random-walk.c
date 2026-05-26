#include <SDL2/SDL.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <math.h>

#define WIDTH        800
#define HEIGHT       600
#define MAX_AGENTS   500
#define INIT_AGENTS  20
#define AGENT_SIZE   3
#define FADE_ALPHA   8      // how fast trails fade (0-255, lower = longer trail)
#define TARGET_FPS   60

/* ── Color ───────────────────────────────────────────────── */
typedef struct { Uint8 r, g, b; } RGB;

RGB hsl2rgb(float h, float s, float l) {
    float q = l < 0.5f ? l * (1 + s) : l + s - l * s;
    float p = 2 * l - q;
    float t[3] = { h + 1.f/3, h, h - 1.f/3 };
    float c[3];
    for (int i = 0; i < 3; i++) {
        float tv = t[i];
        if (tv < 0) tv += 1;
        if (tv > 1) tv -= 1;
        if      (tv < 1.f/6) c[i] = p + (q-p)*6*tv;
        else if (tv < 1.f/2) c[i] = q;
        else if (tv < 2.f/3) c[i] = p + (q-p)*(2.f/3-tv)*6;
        else                 c[i] = p;
    }
    return (RGB){ (Uint8)(c[0]*255), (Uint8)(c[1]*255), (Uint8)(c[2]*255) };
}

/* ── Agent ───────────────────────────────────────────────── */
typedef struct {
    float x, y;
    float hue;        // 0-1, cycles over time
    float hue_speed;  // how fast hue shifts
    int   dx, dy;     // current direction
} Agent;

static Agent agents[MAX_AGENTS];
static int   num_agents = 0;

void agent_init(Agent *a, int x, int y) {
    a->x         = (float)x;
    a->y         = (float)y;
    a->hue       = (float)rand() / RAND_MAX;
    a->hue_speed = 0.001f + ((float)rand() / RAND_MAX) * 0.004f;
    int dirs[4][2] = { {1,0},{-1,0},{0,1},{0,-1} };
    int idx = rand() % 4;
    a->dx = dirs[idx][0];
    a->dy = dirs[idx][1];
}

void agent_move(Agent *a, SDL_Surface *surf, int speed) {
    /* random direction change ~25% chance */
    if (rand() % 4 == 0) {
        int dirs[4][2] = { {1,0},{-1,0},{0,1},{0,-1} };
        int idx = rand() % 4;
        a->dx = dirs[idx][0];
        a->dy = dirs[idx][1];
    }

    for (int s = 0; s < speed; s++) {
        a->x += a->dx;
        a->y += a->dy;

        /* bounce off walls */
        if (a->x < 0)           { a->x = 0;          a->dx *= -1; }
        if (a->x >= WIDTH-1)    { a->x = WIDTH-2;     a->dx *= -1; }
        if (a->y < 0)           { a->y = 0;           a->dy *= -1; }
        if (a->y >= HEIGHT-1)   { a->y = HEIGHT-2;    a->dy *= -1; }

        /* shift hue */
        a->hue += a->hue_speed;
        if (a->hue > 1.f) a->hue -= 1.f;

        RGB rgb = hsl2rgb(a->hue, 1.f, 0.55f);
        SDL_Rect rect = { (int)a->x, (int)a->y, AGENT_SIZE, AGENT_SIZE };
        SDL_FillRect(surf, &rect,
            SDL_MapRGB(surf->format, rgb.r, rgb.g, rgb.b));
    }
}

/* ── Fade overlay ────────────────────────────────────────── */
void fade_surface(SDL_Surface *surf, Uint8 alpha) {
    SDL_Surface *fade = SDL_CreateRGBSurface(0, WIDTH, HEIGHT, 32,
        0x00FF0000, 0x0000FF00, 0x000000FF, 0xFF000000);
    SDL_FillRect(fade, NULL, SDL_MapRGBA(fade->format, 0, 0, 0, alpha));
    SDL_SetSurfaceBlendMode(fade, SDL_BLENDMODE_BLEND);
    SDL_BlitSurface(fade, NULL, surf, NULL);
    SDL_FreeSurface(fade);
}

/* ── HUD text (simple pixel font via SDL_Rect blocks) ────── */
void draw_hud(SDL_Surface *surf, int n, int speed) {
    /* simple top-left info bar */
    SDL_Rect bar = { 0, 0, 260, 22 };
    SDL_FillRect(surf, &bar, SDL_MapRGBA(surf->format, 0, 0, 0, 180));
    (void)n; (void)speed; /* text drawn below via SDL_Surface title */
}

/* ── Main ────────────────────────────────────────────────── */
int main(int argc, char *argv[]) {
    int init_n = INIT_AGENTS;
    if (argc > 1) init_n = atoi(argv[1]);
    if (init_n > MAX_AGENTS) init_n = MAX_AGENTS;

    srand((unsigned)time(NULL));

    if (SDL_Init(SDL_INIT_VIDEO) < 0) {
        fprintf(stderr, "SDL_Init error: %s\n", SDL_GetError());
        return 1;
    }

    SDL_Window *win = SDL_CreateWindow(
        "Random Walk  |  +/- speed  |  click=add agent  |  ESC=quit",
        SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED,
        WIDTH, HEIGHT, SDL_WINDOW_SHOWN);
    if (!win) { SDL_Quit(); return 1; }

    SDL_Surface *surf = SDL_GetWindowSurface(win);
    SDL_FillRect(surf, NULL, SDL_MapRGB(surf->format, 0, 0, 0));

    /* init agents at center */
    for (int i = 0; i < init_n; i++) {
        agent_init(&agents[num_agents++], WIDTH/2, HEIGHT/2);
    }

    int running = 1;
    int speed   = 2;   /* pixels per frame per agent */
    int fade    = 1;   /* toggle trails */
    Uint32 frame_time = 1000 / TARGET_FPS;
    SDL_Event ev;
    char title[128];

    while (running) {
        Uint32 t0 = SDL_GetTicks();

        /* events */
        while (SDL_PollEvent(&ev)) {
            if (ev.type == SDL_QUIT) running = 0;
            if (ev.type == SDL_KEYDOWN) {
                switch (ev.key.keysym.sym) {
                    case SDLK_ESCAPE: running = 0; break;
                    case SDLK_PLUS:
                    case SDLK_EQUALS: if (speed < 20) speed++; break;
                    case SDLK_MINUS:  if (speed > 1)  speed--; break;
                    case SDLK_f:      fade = !fade;   break;
                    case SDLK_r:
                        /* reset canvas */
                        SDL_FillRect(surf, NULL, SDL_MapRGB(surf->format, 0,0,0));
                        break;
                    case SDLK_c:
                        /* clear agents */
                        num_agents = 0;
                        SDL_FillRect(surf, NULL, SDL_MapRGB(surf->format, 0,0,0));
                        break;
                }
            }
            if (ev.type == SDL_MOUSEBUTTONDOWN) {
                if (num_agents < MAX_AGENTS) {
                    agent_init(&agents[num_agents++],
                        ev.button.x, ev.button.y);
                }
            }
        }

        /* fade trails */
        if (fade) fade_surface(surf, FADE_ALPHA);

        /* move agents */
        for (int i = 0; i < num_agents; i++)
            agent_move(&agents[i], surf, speed);

        /* update window title as HUD */
        snprintf(title, sizeof(title),
            "Random Walk  |  agents: %d  |  speed: %d  |  "
            "+/- speed  |  click=add  |  F=trails  |  R=reset  |  C=clear  |  ESC=quit",
            num_agents, speed);
        SDL_SetWindowTitle(win, title);

        SDL_UpdateWindowSurface(win);

        /* cap FPS */
        Uint32 elapsed = SDL_GetTicks() - t0;
        if (elapsed < frame_time)
            SDL_Delay(frame_time - elapsed);
    }

    SDL_DestroyWindow(win);
    SDL_Quit();
    return 0;
}
