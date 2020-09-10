barracuda_file = barracudavpn_5.1.4_amd64.deb
key_directory = ~/.keys
key_path = $(key_directory)/barracuda-vpn-key_rsa
user_file_encrypted = vpn.user
pwd_file_encrypted = vpn.pwd
zhell_path = ~/.zshrc

.PHONY: install # = Install the barracuda-vpn
install:
	sudo dpkg -i $(barracuda_file)

.PHONY: credentials # = Create key and encrypted files for credentials using the key
credentials:
	@ if [ "$(user)" = "" ] || [ "$(pwd)" = "" ]; then \
        echo "Missing parameters! Use 'make test user=value pwd=value'"; \
        exit 1; \
    fi
	mkdir -p $(key_directory)
	openssl genrsa -out $(key_path) 2048
	echo "$(user)" | openssl rsautl -inkey $(key_path) -encrypt > $(user_file_encrypted)
	echo "$(pwd)" | openssl rsautl -inkey $(key_path) -encrypt > $(pwd_file_encrypted)
	sudo chown root:root $(key_path)
	sudo chmod 600 $(key_path)

.PHONY: test # = Connect to the vpn and close the connection
test:
	./vpn-open $(key_path)
	./vpn-close

.PHONY: clean # = Remove the encrypted files for credentials and the key
clean:
	sudo rm $(user_file_encrypted) || true
	sudo rm $(pwd_file_encrypted) || true
	sudo rm $(key_path) || true
	rmdir --ignore-fail-on-non-empty $(key_directory)

.PHONY: configuration # = Create alias vpn and add this directory to PATH in the shell
configuration:
	echo "" >> $(zhell_path)
	echo "" >> $(zhell_path)
	echo "# Used to automate barracuda-vpn" >> $(zhell_path)
	echo "alias vpn=\"vpn-open $(key_path)\"" >> $(zhell_path)
	echo "export PATH=\44PATH:$(PWD)" >> $(zhell_path)

.PHONY: help # = Generate list of targets with descriptions
help:
	@grep '^.PHONY: .* #' Makefile | sed 's/\.PHONY: \(.*\) # \(.*\)/\1 \2/' | expand -t20