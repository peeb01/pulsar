# 🌌 Pulsar HTTP Framework

Pulsar is a lightweight, modular, and high-performance HTTP web framework written entirely in the **NP programming language** and compiled to native machine code via LLVM under WSL.

Inspired by Go's `net/http` and Python's micro-frameworks, Pulsar provides clean abstractions for building fast web APIs and microservices using the NP language.

---

## 🚀 Key Features

* **Modular Subfolders**: Clean code organization separating request handling, response formatting, TCP servers, and utilities.
* **Regex HTTP Parsing**: Fully parses raw HTTP requests to extract methods, paths, query parameters, and headers.
* **Query Parameter Decoder**: Automatically parses query strings (e.g., `?name=Alice&age=25`) into accessible key-value dictionaries.
* **Dynamic Content Types**: Native helpers for plain text (`pulsar_ok`), JSON (`pulsar_json`), redirects (`pulsar_redirect`), and error responses (`pulsar_not_found`, `pulsar_error`).
* **Robust Core Engine**: Pure NP socket implementation mapping connection lifecycles (accept, receive, send, and close).

---

## 📁 Directory Structure

```text
E:\GitHub\peeb01\pulsar\
├── np                     # Compiler binary (WSL)
├── app.np                 # Demo application entry point
├── app.out                # Compiled server executable
├── README.md              # Framework documentation
├── pulsar/                # Core Framework Directory
│   ├── core/              # Core protocol engine
│   │   ├── request.np     # HttpRequest parser
│   │   ├── response.np    # HttpResponse formatter and helpers
│   │   └── server.np      # TCP listening socket server loop
│   ├── utils/             # Utilities
│   │   └── parser.np      # Regex string processing & safe dict helpers
│   └── pulsar.np          # Framework aggregator
└── tests/                 # Test suites
    ├── app_test.np        # Comprehensive framework test suite
    └── test_write.np      # File writing test helper
```

---

## 📦 Using Pulsar as a Package (`np get`)

The NP compiler has a built-in package manager that resolves dependencies from GitHub. You can install and use Pulsar in any new NP project:

### 1. Create a Dependency File
In your new project root, create a file named `np.req` specifying the Pulsar repository and the target version tag (e.g., `main` or a specific release):
```text
# np.req
github.com/peeb01/pulsar main
```

### 2. Download the Package
Run the package manager in your terminal to fetch and verify the dependency:
```bash
wsl ./np get
```
This automatically clones Pulsar into `.np_packages/github.com/peeb01/pulsar/`.

### 3. Import and Use in Your Code
In your project files, import the package prefix and structure your code:

```python
# 1. Import response & request modules with package prefix
import "github.com/peeb01/pulsar/pulsar/core/response.np"
import "github.com/peeb01/pulsar/github.com/peeb01/pulsar/pulsar/core/request.np"

# 2. Define the application routing function
fn pulsar_route(dict req) -> dict:
    string path = dict_get_string(req, "path")
    if path == "/":
        return pulsar_ok("Hello from Pulsar Package!")
    return pulsar_not_found("404 Not Found")

# 3. Import the server engine and start
import "github.com/peeb01/pulsar/pulsar/core/server.np"

pulsar_serve(8080)
```

---

## 🔧 Compiler Workarounds & Best Practices

Since the current NP compiler LLVM backend has specific architectural constraints, Pulsar implements several design patterns to guarantee stability and performance:

1. **Dictionary-Based Objects (No Struct Codegen)**:
   The compiler's LLVM backend does not support struct code generation. Requests and responses are represented as standard dictionaries (`dict`), which compile and run perfectly.
2. **Safe Dictionary Helpers**:
   The compiler's dictionary literal and indexing codegen has a type-mismatch bug where it passes C++ string objects instead of C-string pointers to the runtime. We bypass this using explicit C-string casts via **Safe Dictionary Helpers** (`dict_set_string`, `dict_get_string`, etc.).
3. **No Forward References**:
   The NP compiler requires all functions to be defined before they are called. When writing web applications, imports must be structured in a specific order:
   - Import `request.np` and `response.np` first (defines request structures and response helpers).
   - Define the route handler function `pulsar_route`.
   - Import `server.np` (defines the server loop which calls the route handler).
   - Start the server using `pulsar_serve`.

---

## 🛠️ Building and Running

### Compile the Web Application
Compile your entry point (`app.np`) into a native binary (`app.out`) using WSL:
```bash
wsl ./np build app.np
```

### Run the Web Server
Execute the compiled binary:
```bash
wsl ./app.out
```

### Test the API
Test the running endpoints using `curl`:
```bash
# Text Endpoint
curl -i http://localhost:8080/

# JSON Endpoint
curl -i http://localhost:8080/json

# Query Parameters
curl -i http://localhost:8080/greet?name=Pulsar
```

---

## 🧪 Running Tests

A comprehensive modular test suite is provided in `tests/app_test.np`. To run it:
```bash
wsl ./np tests/app_test.np
```
