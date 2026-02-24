#!/usr/bin/env bash
set -e

echo "Generating oracle solution..."

cat > /workspace/discovered_equation.txt << 'EQUATION'
n = 2*pi*L/h
EQUATION

echo "Oracle solution generated: 2*pi*L/h"
