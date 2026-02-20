// ============================================================================
//  Project : RPG Inventory System — C++ Showcase
//  Author  : Miles3103
//  Topic   : Project — OOP, templates, STL, smart ptrs, exceptions, modern C++
// ============================================================================

/*
** SHOWCASE PROJECT — Everything combined.
**
** This project uses:
**   ✓ Abstract base classes & inheritance
**   ✓ Polymorphism (virtual functions)
**   ✓ Templates (generic containers)
**   ✓ Smart pointers (unique_ptr, shared_ptr)
**   ✓ STL (vector, map, algorithm)
**   ✓ Custom exceptions
**   ✓ Operator overloading
**   ✓ Modern C++ (auto, lambdas, range-for, structured bindings)
**   ✓ RAII
**   ✓ Const correctness
*/

#include <iostream>
#include <string>
#include <vector>
#include <map>
#include <memory>
#include <algorithm>
#include <stdexcept>
#include <iomanip>   // std::setw, std::left

// ============================================================================
//  EXCEPTIONS
// ============================================================================

class InventoryException : public std::exception
{
private:
    std::string _msg;
public:
    explicit InventoryException(const std::string& msg) : _msg(msg) {}
    const char* what() const noexcept override { return _msg.c_str(); }
};

// ============================================================================
//  ABSTRACT BASE CLASS: Item
// ============================================================================

class Item
{
protected:
    std::string _name;
    std::string _description;
    int         _value;     // gold value
    int         _weight;    // in grams
    int         _quantity;

public:
    Item(const std::string& name, const std::string& desc,
         int value, int weight, int qty = 1)
        : _name(name), _description(desc),
          _value(value), _weight(weight), _quantity(qty) {}

    virtual ~Item() = default;

    // Pure virtual — every item must have a type and use action
    virtual std::string type()    const = 0;
    virtual std::string use()     const = 0;

    // Virtual with default — can be overridden
    virtual void    display() const
    {
        std::cout << std::left
                  << std::setw(12) << type()
                  << std::setw(18) << _name
                  << std::setw(6)  << _quantity
                  << std::setw(8)  << (_value * _quantity)
                  << _description << '\n';
    }

    // Getters
    const std::string&  name()     const { return _name;     }
    const std::string&  desc()     const { return _description; }
    int                 value()    const { return _value;    }
    int                 weight()   const { return _weight;   }
    int                 quantity() const { return _quantity; }

    void    addQuantity(int n)
    {
        if (_quantity + n < 0)
            throw InventoryException("Cannot reduce " + _name + " below 0");
        _quantity += n;
    }

    // Operator overloading — compare by value
    bool    operator<(const Item& other) const { return _value < other._value; }
    bool    operator==(const Item& other) const { return _name == other._name; }
};

// ============================================================================
//  DERIVED ITEM TYPES
// ============================================================================

class Weapon : public Item
{
private:
    int         _damage;
    std::string _damage_type;

public:
    Weapon(const std::string& name, int damage, const std::string& dtype,
           int value, int weight)
        : Item(name, "Deals " + std::to_string(damage) + " " + dtype + " damage",
               value, weight),
          _damage(damage), _damage_type(dtype) {}

    std::string type() const override { return "[Weapon]"; }

    std::string use() const override
    {
        return "You attack with " + _name + " for " +
               std::to_string(_damage) + " " + _damage_type + " damage!";
    }

    int         getDamage()    const { return _damage;      }
    std::string getDamageType() const { return _damage_type; }
};

class Armor : public Item
{
private:
    int     _defense;
    std::string _slot;   // head, chest, legs, etc.

public:
    Armor(const std::string& name, int defense, const std::string& slot,
          int value, int weight)
        : Item(name, "Provides " + std::to_string(defense) + " defense",
               value, weight),
          _defense(defense), _slot(slot) {}

    std::string type()   const override { return "[Armor]";  }
    std::string slot()   const { return _slot;    }
    int         defense() const { return _defense; }

    std::string use() const override
    {
        return "You equip " + _name + " (" + _slot + ")";
    }
};

class Consumable : public Item
{
private:
    int         _effect;
    std::string _effect_type;  // heal, mana, stamina

public:
    Consumable(const std::string& name, int effect, const std::string& etype,
               int value, int weight, int qty = 1)
        : Item(name, "Restores " + std::to_string(effect) + " " + etype,
               value, weight, qty),
          _effect(effect), _effect_type(etype) {}

    std::string type() const override { return "[Potion]"; }

    std::string use() const override
    {
        if (_quantity <= 0)
            throw InventoryException("No " + _name + " remaining!");
        return "You drink " + _name + " and restore " +
               std::to_string(_effect) + " " + _effect_type + "!";
    }

    int         effect()     const { return _effect;      }
    std::string effectType() const { return _effect_type; }
};

// ============================================================================
//  TEMPLATE CLASS: Inventory<T>
// ============================================================================

template <typename T>
class Inventory
{
private:
    std::vector<std::shared_ptr<T>>     _items;
    int                                  _max_weight;
    int                                  _current_weight;

public:
    explicit Inventory(int max_weight = 50000)
        : _max_weight(max_weight), _current_weight(0) {}

    void    add(std::shared_ptr<T> item)
    {
        if (_current_weight + item->weight() > _max_weight)
            throw InventoryException("Inventory too heavy to add " + item->name());
        _items.push_back(item);
        _current_weight += item->weight();
    }

    bool    remove(const std::string& name)
    {
        auto it = std::find_if(_items.begin(), _items.end(),
            [&name](const auto& item) { return item->name() == name; });
        if (it == _items.end())
            return false;
        _current_weight -= (*it)->weight();
        _items.erase(it);
        return true;
    }

    std::shared_ptr<T>  find(const std::string& name) const
    {
        auto it = std::find_if(_items.begin(), _items.end(),
            [&name](const auto& item) { return item->name() == name; });
        return (it != _items.end()) ? *it : nullptr;
    }

    void    sortByValue()
    {
        std::sort(_items.begin(), _items.end(),
            [](const auto& a, const auto& b) {
                return a->value() > b->value();
            });
    }

    int     totalValue()  const
    {
        int sum = 0;
        for (const auto& item : _items)
            sum += item->value() * item->quantity();
        return sum;
    }

    void    display() const
    {
        std::cout << std::left
                  << std::setw(12) << "Type"
                  << std::setw(18) << "Name"
                  << std::setw(6)  << "Qty"
                  << std::setw(8)  << "Gold"
                  << "Description" << '\n';
        std::cout << std::string(70, '-') << '\n';
        for (const auto& item : _items)
            item->display();
        std::cout << std::string(70, '-') << '\n';
        std::cout << "Items: " << _items.size()
                  << " | Total value: " << totalValue() << "g"
                  << " | Weight: " << _current_weight << "/" << _max_weight << "g\n";
    }

    size_t  size()   const { return _items.size();       }
    bool    empty()  const { return _items.empty();      }
    int     weight() const { return _current_weight;     }

    // Range-based for loop support
    auto    begin() { return _items.begin(); }
    auto    end()   { return _items.end();   }
};

// ============================================================================
//  PLAYER CLASS
// ============================================================================

class Player
{
private:
    std::string             _name;
    int                     _hp;
    int                     _max_hp;
    int                     _gold;
    Inventory<Item>         _inventory;

public:
    Player(const std::string& name, int hp, int gold)
        : _name(name), _hp(hp), _max_hp(hp), _gold(gold), _inventory(30000) {}

    void    pickup(std::shared_ptr<Item> item)
    {
        try
        {
            _inventory.add(item);
            std::cout << _name << " picked up: " << item->name() << '\n';
        }
        catch (const InventoryException& e)
        {
            std::cout << "Cannot pick up: " << e.what() << '\n';
        }
    }

    void    use_item(const std::string& name)
    {
        auto item = _inventory.find(name);
        if (!item)
        {
            std::cout << "Item not found: " << name << '\n';
            return ;
        }
        try
        {
            std::cout << item->use() << '\n';
        }
        catch (const InventoryException& e)
        {
            std::cout << e.what() << '\n';
        }
    }

    void    show_status() const
    {
        std::cout << "\n╔══════════════════════════════════╗\n";
        std::cout << "║  Player: " << std::left << std::setw(24) << _name << "║\n";
        std::cout << "║  HP:     " << std::setw(24) << (_name + ": " + std::to_string(_hp) + "/" + std::to_string(_max_hp)).substr(_name.length() + 2) << "║\n";
        std::cout << "║  Gold:   " << std::left << std::setw(24) << _gold << "║\n";
        std::cout << "╚══════════════════════════════════╝\n";
    }

    void    show_inventory()
    {
        std::cout << "\n=== " << _name << "'s Inventory ===\n";
        if (_inventory.empty())
            std::cout << "(empty)\n";
        else
        {
            _inventory.sortByValue();
            _inventory.display();
        }
    }

    const std::string&  name() const { return _name; }
};

// ============================================================================
//  MAIN
// ============================================================================

int     main()
{
    std::cout << "╔══════════════════════════════════════════╗\n";
    std::cout << "║    RPG INVENTORY SYSTEM — Miles3103     ║\n";
    std::cout << "╚══════════════════════════════════════════╝\n\n";

    Player  hero("Miles3103", 100, 500);

    // Create items using smart pointers
    auto    sword    = std::make_shared<Weapon>("Iron Sword", 25, "physical", 150, 2000);
    auto    bow      = std::make_shared<Weapon>("Elven Bow",  18, "piercing", 200, 800);
    auto    shield   = std::make_shared<Armor>("Oak Shield",  15, "offhand",  80,  3000);
    auto    helmet   = std::make_shared<Armor>("Steel Helm",  10, "head",     120, 1500);
    auto    potion1  = std::make_shared<Consumable>("Health Potion",   50, "HP", 25, 200, 3);
    auto    potion2  = std::make_shared<Consumable>("Mana Potion",     30, "MP", 20, 150, 2);

    // Pick up items
    hero.pickup(sword);
    hero.pickup(bow);
    hero.pickup(shield);
    hero.pickup(helmet);
    hero.pickup(potion1);
    hero.pickup(potion2);

    // Show inventory
    hero.show_inventory();

    // Use items
    std::cout << "\n=== Combat ===\n";
    hero.use_item("Iron Sword");
    hero.use_item("Elven Bow");

    std::cout << "\n=== Healing ===\n";
    hero.use_item("Health Potion");

    std::cout << "\n=== Exception Handling ===\n";
    hero.use_item("Dragon Sword");  // not in inventory

    return (0);
}
