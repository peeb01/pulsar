#!/bin/sh
set -e

echo "======================================"
echo "      Pulsar Framework TDD Suite      "
echo "======================================"

echo ""
echo ">>> 1. Testing Response Module..."
np tests/test_response.np

echo ""
echo ">>> 2. Testing Request & Parser Module..."
np tests/test_request.np

echo ""
echo ">>> 3. Testing Logger & Time Module..."
np tests/test_logger.np

echo ""
echo ">>> 4. Testing Package Import Architecture..."
np tests/test_import.np

echo ""
echo ">>> 5. Testing Full App Integration..."
np tests/app_test.np

echo ""
echo "======================================"
echo "   ALL TDD SUITES PASSED (100%)       "
echo "======================================"
