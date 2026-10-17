# 42 Piscine: Shell 01 - Exercise 04 (MAC.sh)

An educational guide explaining how to extract and isolate all physical MAC addresses from your machine's network interface configuration using standard command-line tools.

## 📋 The Assignment

The goal is to create a single script file named `MAC.sh` inside the `ex04/` directory. It must contain exactly **one command line** that identifies and displays all MAC addresses assigned to your computer's active network hardware cards. Each address must be output on a completely separate line.

---

## 💡 The Solution

When you run `ifconfig`, the system returns a large volume of configuration statistics for every network adapter. Physical MAC addresses are specifically prefixed by the identifier string `ether`. We can parse out just the addresses using text manipulation utilities.

Place this exact line inside your `MAC.sh` file:

```bash
ifconfig -a | grep "ether " | awk '{print \$2}'
```

### 🔍 Detailed Command Breakdown

| Component | Role |
| :--- | :--- |
| `ifconfig -a` | Queries the system configuration for **all** network interfaces (both active and inactive). |
| `grep "ether "` | Filters the verbose output, capturing only lines containing the term `ether` (which marks standard Ethernet and Wi-Fi hardware addresses). |
| `awk '{print $2}'` | Splits each matching line cleanly by empty whitespace columns and prints out only the **second column**—which holds the pure `xx:xx:xx:xx:xx:xx` MAC string. |

---

## 🛠️ Setup and Testing

To verify that your text filters work flawlessly without leaving any unwanted trailing parameters, run these verification steps:

1. **Make your script executable**:
   ```bash
   chmod +x MAC.sh
   ```

2. **Execute the script directly**:
   ```bash
   ./MAC.sh
   ```

3. **Expected Output Style**:
   Your terminal should return clean strings representing your local hardware targets (e.g., your active Wi-Fi chip or physical LAN link), matching this structure:
   ```bash
   a1:b2:c3:d4:e5:f6
   07:89:ab:cd:ef:01
   ```

4. **Hidden Check with `cat -e`**:
   Ensure there are no leading or trailing whitespace characters wrapping your addresses:
   ```bash
   ./MAC.sh | cat -e
   ```
   **Correct Output:**
   ```bash
   a1:b2:c3:d4:e5:f6\(07:89:ab:cd:ef:01\)
   ```

---

## 📦 Submission

Ensure your `ex04/` directory only contains the `MAC.sh` script file before pushing your project to Git.

