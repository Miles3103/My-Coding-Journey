// ============================================================================
//  RPG Inventory System — FIXED VERSION
// ============================================================================

#include <iostream>
#include <string>
#include <vector>
#include <memory>
#include <algorithm>
#include <stdexcept>
#include <iomanip>

// ============================================================================
// EXCEPTION
// ============================================================================

class InventoryException : public std::exception
{
    std::string _msg;
public:
    explicit InventoryException(const std::string& msg) : _msg(msg) {}
    const char* what() const noexcept override { return _msg.c_str(); }
};

// ============================================================================
// ITEM BASE CLASS
// ============================================================================

class Item
{
protected:
    std::string _name;
    std::string _description;
    int _value;
    int _weight;
    int _quantity;

public:
    Item(const std::string& name,const std::string& desc,
         int value,int weight,int qty=1)
        : _name(name),_description(desc),
          _value(value),_weight(weight),_quantity(qty){}

    virtual ~Item() = default;

    virtual std::string type() const = 0;
    virtual std::string use() = 0;        // ✅ removed const

    virtual void display() const
    {
        std::cout << std::left
                  << std::setw(12) << type()
                  << std::setw(18) << _name
                  << std::setw(6)  << _quantity
                  << std::setw(8)  << (_value * _quantity)
                  << _description << '\n';
    }

    const std::string& name() const { return _name; }
    int value() const { return _value; }
    int weight() const { return _weight; }
    int quantity() const { return _quantity; }

    void addQuantity(int n)
    {
        if (_quantity + n < 0)
            throw InventoryException("Quantity below zero");
        _quantity += n;
    }

    bool empty() const { return _quantity <= 0; } // ✅ NEW
};

// ============================================================================
// WEAPON
// ============================================================================

class Weapon : public Item
{
    int _damage;
    std::string _dtype;

public:
    Weapon(const std::string& n,int dmg,const std::string& dt,
           int value,int weight)
        : Item(n,"Deals "+std::to_string(dmg)+" "+dt+" damage",
               value,weight),
          _damage(dmg),_dtype(dt){}

    std::string type() const override { return "[Weapon]"; }

    std::string use() override
    {
        return "You attack with "+_name+" for "+
               std::to_string(_damage)+" "+_dtype+" damage!";
    }
};

// ============================================================================
// ARMOR
// ============================================================================

class Armor : public Item
{
    int _def;
    std::string _slot;

public:
    Armor(const std::string& n,int d,const std::string& slot,
          int value,int weight)
        : Item(n,"Provides "+std::to_string(d)+" defense",
               value,weight),
          _def(d),_slot(slot){}

    std::string type() const override { return "[Armor]"; }

    std::string use() override
    {
        return "You equip "+_name+" ("+_slot+")";
    }
};

// ============================================================================
// CONSUMABLE  ✅ FIXED
// ============================================================================

class Consumable : public Item
{
    int _effect;
    std::string _etype;

public:
    Consumable(const std::string& n,int e,const std::string& t,
               int value,int weight,int qty=1)
        : Item(n,"Restores "+std::to_string(e)+" "+t,
               value,weight,qty),
          _effect(e),_etype(t){}

    std::string type() const override { return "[Potion]"; }

    std::string use() override
    {
        if (_quantity <= 0)
            throw InventoryException("No "+_name+" remaining!");

        --_quantity;                 // ✅ consume item

        return "You drink "+_name+
               " and restore "+
               std::to_string(_effect)+" "+_etype+"!";
    }
};

// ============================================================================
// INVENTORY TEMPLATE
// ============================================================================

template<typename T>
class Inventory
{
    std::vector<std::shared_ptr<T>> _items;
    int _max_weight;
    int _current_weight{0};

public:
    explicit Inventory(int max=50000):_max_weight(max){}

    void add(std::shared_ptr<T> item)
    {
        int added = item->weight()*item->quantity(); // ✅ FIX

        if (_current_weight + added > _max_weight)
            throw InventoryException("Inventory too heavy");

        _items.push_back(item);
        _current_weight += added;
    }

    bool remove(const std::string& name)
    {
        auto it = std::find_if(_items.begin(),_items.end(),
            [&](auto& i){return i->name()==name;});

        if(it==_items.end()) return false;

        _current_weight -=
            (*it)->weight()*(*it)->quantity(); // ✅ FIX

        _items.erase(it);
        return true;
    }

    std::shared_ptr<T> find(const std::string& name)
    {
        auto it = std::find_if(_items.begin(),_items.end(),
            [&](auto& i){return i->name()==name;});

        return it!=_items.end()?*it:nullptr;
    }

    void display() const
    {
        std::cout<<std::string(70,'-')<<"\n";
        for(const auto& i:_items)
            i->display();
        std::cout<<std::string(70,'-')<<"\n";
    }

    bool empty() const { return _items.empty(); }
};

// ============================================================================
// PLAYER
// ============================================================================

class Player
{
    std::string _name;
    Inventory<Item> _inventory;

public:
    Player(const std::string& n):_name(n),_inventory(30000){}

    void pickup(std::shared_ptr<Item> item)
    {
        _inventory.add(item);
        std::cout<<_name<<" picked up: "
                 <<item->name()<<"\n";
    }

    void use_item(const std::string& name)
    {
        auto item=_inventory.find(name);

        if(!item)
        {
            std::cout<<"Item not found: "<<name<<"\n";
            return;
        }

        try
        {
            std::cout<<item->use()<<"\n";

            if(item->empty())          // ✅ auto remove
            {
                _inventory.remove(name);
                std::cout<<name
                         <<" depleted and removed\n";
            }
        }
        catch(const InventoryException& e)
        {
            std::cout<<e.what()<<"\n";
        }
    }

    void show_inventory()
    {
        if(_inventory.empty())
            std::cout<<"(empty)\n";
        else
            _inventory.display();
    }
};

// ============================================================================
// MAIN
// ============================================================================

int main()
{
    Player hero("Miles3103");

    auto potion =
        std::make_shared<Consumable>(
            "Health Potion",50,"HP",25,200,3);

    hero.pickup(potion);

    hero.show_inventory();

    hero.use_item("Health Potion");
    hero.use_item("Health Potion");
    hero.use_item("Health Potion"); // removed after this

    hero.show_inventory();
}
