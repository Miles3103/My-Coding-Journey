// ============================================================================
//  Project : STL — Standard Template Library
//  Author  : Miles3103
//  Topic   : STL — vector, map, set, string, algorithms, iterators
// ============================================================================

/*
** THE STL — YOUR MOST POWERFUL TOOLBOX
**
** The STL has three main parts:
**
**   1. CONTAINERS — data structures that hold elements
**      vector<T>      → dynamic array (like C array but auto-resizes)
**      list<T>        → doubly-linked list
**      map<K,V>       → key-value store (sorted, like dictionary)
**      unordered_map  → key-value store (hash table, faster lookup)
**      set<T>         → unique sorted values
**      queue/stack    → FIFO/LIFO adapters
**      array<T,N>     → fixed-size array with STL interface
**
**   2. ALGORITHMS — functions that work on containers
**      sort, find, count, transform, for_each, any_of, all_of...
**      #include <algorithm>
**
**   3. ITERATORS — pointers that work across all containers
**      begin(), end(), rbegin(), rend()
**      Algorithms use iterators — works the same on any container
**
** WHEN TO USE WHAT:
**   Need fast random access?     → vector
**   Need fast insert/erase?      → list
**   Need key-value lookup?       → map / unordered_map
**   Need unique elements?        → set
**   Need stack behavior?         → stack
**   Need queue behavior?         → queue
*/

#include <iostream>
#include <vector>
#include <map>
#include <unordered_map>
#include <set>
#include <string>
#include <algorithm>   // sort, find, count, transform, etc.
#include <numeric>     // accumulate, iota
#include <iterator>    // begin, end

// ============================================================================
//  VECTOR<T> — your go-to dynamic array
// ============================================================================

void    demo_vector()
{
    std::cout << "=== std::vector ===\n";

    // Create and populate
    std::vector<int>    v = {5, 3, 8, 1, 9, 2, 7, 4, 6};

    std::cout << "size=" << v.size() << " capacity=" << v.capacity() << '\n';

    // push_back adds to end
    v.push_back(10);
    v.push_back(0);

    // Access
    std::cout << "front=" << v.front() << " back=" << v.back() << '\n';
    std::cout << "v[4]=" << v[4] << "  v.at(4)=" << v.at(4) << '\n';
    // at() throws std::out_of_range, [] doesn't — prefer at() for safety

    // Range-based for loop (C++11)
    std::cout << "all: ";
    for (const int& n : v)
        std::cout << n << ' ';
    std::cout << '\n';

    // Sort
    std::sort(v.begin(), v.end());
    std::cout << "sorted: ";
    for (const int& n : v) std::cout << n << ' ';
    std::cout << '\n';

    // Find
    auto    it = std::find(v.begin(), v.end(), 7);
    if (it != v.end())
        std::cout << "found 7 at index " << (it - v.begin()) << '\n';

    // Erase
    v.erase(v.begin() + 2);  // remove element at index 2
    std::cout << "after erase[2]: ";
    for (const int& n : v) std::cout << n << ' ';
    std::cout << '\n';

    // Insert
    v.insert(v.begin() + 2, 99);  // insert 99 at index 2
    std::cout << "after insert 99 at [2]: ";
    for (const int& n : v) std::cout << n << ' ';
    std::cout << '\n';

    // Sum with accumulate
    int sum = std::accumulate(v.begin(), v.end(), 0);
    std::cout << "sum=" << sum << '\n';
    std::cout << '\n';
}

// ============================================================================
//  MAP<K,V> — sorted key-value store
// ============================================================================

void    demo_map()
{
    std::cout << "=== std::map ===\n";

    std::map<std::string, int>  scores;

    // Insert
    scores["Alice"]      = 95;
    scores["Bob"]        = 82;
    scores["Miles3103"]  = 88;
    scores["Charlie"]    = 71;
    scores.insert({"Diana", 90});

    // Iterate (always sorted by key)
    std::cout << "All scores (sorted by name):\n";
    for (const auto& [name, score] : scores)   // C++17 structured bindings
        std::cout << "  " << name << ": " << score << '\n';

    // Lookup
    std::string key = "Bob";
    if (scores.count(key))
        std::cout << key << "'s score: " << scores[key] << '\n';

    // find() — safer than [] for lookup
    auto it = scores.find("Ghost");
    if (it == scores.end())
        std::cout << "Ghost not found\n";

    // Erase
    scores.erase("Bob");
    std::cout << "After erasing Bob: " << scores.size() << " entries\n\n";
}

// ============================================================================
//  UNORDERED_MAP — hash table (O(1) lookup vs O(log n) for map)
// ============================================================================

void    demo_unordered_map()
{
    std::cout << "=== std::unordered_map (word frequency) ===\n";

    std::string                         text = "the cat sat on the mat the cat";
    std::unordered_map<std::string, int> freq;

    // Count word frequency
    std::string word;
    for (size_t i = 0; i <= text.size(); i++)
    {
        if (i == text.size() || text[i] == ' ')
        {
            if (!word.empty())
            {
                freq[word]++;
                word.clear();
            }
        }
        else
            word += text[i];
    }

    for (const auto& [w, count] : freq)
        std::cout << "  \"" << w << "\": " << count << '\n';
    std::cout << '\n';
}

// ============================================================================
//  SET<T> — unique sorted elements
// ============================================================================

void    demo_set()
{
    std::cout << "=== std::set (unique values) ===\n";

    std::set<int>   s = {5, 3, 8, 3, 1, 8, 9, 5};  // duplicates removed
    std::cout << "After inserting {5,3,8,3,1,8,9,5}: ";
    for (int n : s) std::cout << n << ' ';
    std::cout << '\n';
    std::cout << "size=" << s.size() << " (duplicates removed)\n\n";
}

// ============================================================================
//  ALGORITHMS — transform, count_if, any_of, all_of
// ============================================================================

void    demo_algorithms()
{
    std::cout << "=== STL Algorithms ===\n";

    std::vector<int>    v = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};

    // count_if — count elements satisfying condition
    int evens = std::count_if(v.begin(), v.end(),
        [](int n) { return n % 2 == 0; });
    std::cout << "Even numbers: " << evens << '\n';

    // any_of / all_of / none_of
    bool any_gt_5 = std::any_of(v.begin(), v.end(), [](int n){ return n > 5; });
    bool all_gt_0 = std::all_of(v.begin(), v.end(), [](int n){ return n > 0; });
    std::cout << "any > 5: " << (any_gt_5 ? "yes" : "no") << '\n';
    std::cout << "all > 0: " << (all_gt_0 ? "yes" : "no") << '\n';

    // transform — apply function to each element, store result
    std::vector<int>    doubled(v.size());
    std::transform(v.begin(), v.end(), doubled.begin(),
        [](int n) { return n * 2; });
    std::cout << "doubled: ";
    for (int n : doubled) std::cout << n << ' ';
    std::cout << '\n';

    // for_each — apply side effect to each element
    std::cout << "squares: ";
    std::for_each(v.begin(), v.end(),
        [](int n) { std::cout << n * n << ' '; });
    std::cout << '\n';

    // sort with custom comparator
    std::vector<std::string> words = {"banana", "apple", "cherry", "date"};
    std::sort(words.begin(), words.end(),
        [](const std::string& a, const std::string& b) {
            return a.length() < b.length();  // sort by length
        });
    std::cout << "sorted by length: ";
    for (const auto& w : words) std::cout << w << ' ';
    std::cout << '\n';

    // min_element / max_element
    auto min_it = std::min_element(v.begin(), v.end());
    auto max_it = std::max_element(v.begin(), v.end());
    std::cout << "min=" << *min_it << " max=" << *max_it << '\n';

    // reverse
    std::reverse(v.begin(), v.end());
    std::cout << "reversed: ";
    for (int n : v) std::cout << n << ' ';
    std::cout << '\n';
}

// ============================================================================
//  MAIN
// ============================================================================

int     main()
{
    demo_vector();
    demo_map();
    demo_unordered_map();
    demo_set();
    demo_algorithms();

    return (0);
}
