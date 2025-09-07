# Define variables
BIN_NAME := slideshow
INSTALL_PATH := /usr/local/bin
TARGET_DIR := target/release

# Default target
all: release

# Build in release mode
release:
	cargo build --release

# Install the binary to /usr/local/bin
install:
	sudo install -m 755 $(TARGET_DIR)/$(BIN_NAME) $(INSTALL_PATH)/$(BIN_NAME)

# Uninstall by removing the installed binary
uninstall:
	sudo rm -f $(INSTALL_PATH)/$(BIN_NAME)

# Clean the build artifacts
clean:
	cargo clean

