# 🌌 Pulsar HTTP Framework

Pulsar is a lightweight, modular, and high-performance HTTP web framework written entirely in the **NP programming language** and compiled to native machine code via LLVM.

Inspired by Go's `net/http` and `Gin`/`Fiber`, Pulsar provides clean abstractions for building fast web APIs and microservices using the NP language.

---

## 🚀 Key Features

* **Modular Subfolders**: Clean code organization separating request handling, response formatting, TCP servers, and utilities.
* **Modern `func` Syntax**: Fully leverages NP's `func` keyword definition.
* **Regex HTTP Parsing**: Fully parses raw HTTP requests to extract methods, paths, query parameters, and headers.
* **Query Parameter Decoder**: Automatically parses query strings (e.g., `?name=Alice&age=25`) into accessible key-value dictionaries.
* **Dynamic Content Types**: Native helpers for plain text (`pulsar_ok`, `pulsar_text`), HTML (`pulsar_html`), JSON (`pulsar_json`), redirects (`pulsar_redirect`), and error responses (`pulsar_not_found`, `pulsar_bad_request`, `pulsar_unauthorized`, `pulsar_forbidden`, `pulsar_error`).
* **Clean Framed Startup Banner**: Elegant ASCII framed banner displaying port, local URL, and operational status.
* **Configurable Access Logging & Time Formats**:
  - Structured Gin/Fiber style logs: `[PULSAR] [TIME] 200 OK | GET /`
  - Default time format: `MM:SS:MS` (e.g., `07:57:057`)
  - Configurable precision up to: `DD:MM:SS:MS:MicroSec` (e.g., `29:07:57:057:981`)
* **Merge Log Support**: Easily merge custom application logs into the default Pulsar access log line on a per-request basis (`pulsar_with_log`) or server-wide (`pulsar_serve_custom`).
* **Robust Core Engine**: Pure NP socket implementation mapping connection lifecycles (accept, receive, send, and close).

---

## 📁 Directory Structure

```text
pulsar/
├── app.np                 # Demo application entry point
├── app.out                # Compiled server executable
├── README.md              # Framework documentation
├── pulsar/                # Core Framework Directory
│   ├── core/              # Core protocol engine
│   │   ├── request.np     # HttpRequest parser
│   │   ├── response.np    # HttpResponse formatter and helpers
│   │   └── server.np      # TCP listening socket server loop & banner
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
np get
```
This automatically clones Pulsar into `.np_packages/github.com/peeb01/pulsar/`.

### 3. Import and Use in Your Code
In your project files, import Pulsar directly using NP's package entry point resolution:

```python
# 1. Import Pulsar HTTP framework (loads request & response helpers)
import "pulsar"

# 2. Define your application routing function
func pulsar_route(dict req) -> dict:
    string path = dict_get_string(req, "path")
    if path == "/":
        return pulsar_ok("Hello from Pulsar Package!")
    elif path == "/custom":
        dict resp = pulsar_ok("Custom response")
        # Merge extra logs into Pulsar access log line
        return pulsar_with_log(resp, "user_id=101 role=admin")
    return pulsar_not_found("404 Not Found")

# 3. Import server engine and start
import "pulsar/server"

# Start server with default time format (MM:SS:MS)
pulsar_serve(8080)

# Or with custom time format (e.g. DD:MM:SS:MS:MicroSec)
# pulsar_serve_with_format(8080, "DD:MM:SS:MS:MicroSec")
```

#### Alternative: Go-Style Grouped Imports or Remote Package Path
NP also supports Go-style grouped imports and remote paths:
```python
import (
    "pulsar"
)
# or direct remote import:
# import "github.com/peeb01/pulsar"
```

---

## ⏱️ Access Logging & Time Formats

Pulsar produces high-visibility structured access logs for each handled HTTP request:
```text
[PULSAR] [07:57:057] 200 OK | GET /
[PULSAR] [07:57:057] 200 OK | GET /json | handler=json response_bytes=15
```

### Supported Time Formats:
- **Default (`MM:SS:MS`)**: Minutes, Seconds, Milliseconds (e.g. `07:57:057`)
- **Full Precision (`DD:MM:SS:MS:MicroSec`)**: Day, Minutes, Seconds, Milliseconds, Microseconds (e.g. `29:07:57:057:981`)
- **DateTime (`DD:HH:MM:SS:MS:MicroSec`)**: Day, Hours, Minutes, Seconds, Milliseconds, Microseconds
- **Standard (`HH:MM:SS:MS`)** / **(`HH:MM:SS`)**

### Merging Custom Logs:
Attach custom diagnostics or metadata to your response in the route handler:
```python
dict resp = pulsar_ok("Saved")
return pulsar_with_log(resp, "action=save user=alice latency=1ms")
```
Pulsar will automatically merge it at the end of the log line:
```text
[PULSAR] [07:57:057] 200 OK | POST /submit | action=save user=alice latency=1ms
```

---

## 🔧 Compiler Best Practices

1. **Dictionary-Based Objects**:
   Requests and responses are represented as dictionaries (`dict`), which compile directly to native machine code via NP's LLVM backend.
2. **Safe Dictionary Helpers**:
   Safe dictionary helpers (`dict_set_string`, `dict_get_string`, etc.) guarantee memory safety and string compatibility.
3. **No Forward References**:
   NP requires functions to be declared before they are called:
   - Import `request.np` and `response.np`.
   - Define the route handler function `pulsar_route`.
   - Import `server.np`.
   - Start the server using `pulsar_serve` or `pulsar_serve_with_format`.

---

## 🛠️ Building and Running

### Compile the Web Application
Compile your entry point (`app.np`) into a native binary (`app.out`):
```bash
np build app.np
```

### Run the Web Server
Execute the compiled binary:
```bash
./app.out
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

## 🧪 Running Tests (TDD Suite)

Pulsar maintains a comprehensive modular TDD test suite in the `tests/` directory:

| Test File | Description |
| :--- | :--- |
| [`tests/test_response.np`](tests/test_response.np) | Unit tests for response helpers, status codes, JSON/HTML formatting, and headers |
| [`tests/test_request.np`](tests/test_request.np) | Unit tests for string trim, header parsing, query decoding, and raw request parsing |
| [`tests/test_logger.np`](tests/test_logger.np) | Unit tests for digit padding, time formatting precision, and merge log capabilities |
| [`tests/test_import.np`](tests/test_import.np) | Unit tests for package entry point resolution and server module wiring |
| [`tests/app_test.np`](tests/app_test.np) | End-to-end integration test suite |

### Run Individual Test Suites:
```bash
np tests/test_response.np
np tests/test_request.np
np tests/test_logger.np
np tests/test_import.np
np tests/app_test.np
```

### Run All Tests:
```bash
sh tests/run_all.sh
```
