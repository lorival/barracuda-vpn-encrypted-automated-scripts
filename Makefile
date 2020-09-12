barracuda_file = barracudavpn_5.1.4_amd64.deb
key_directory = ~/.barracuda-vpn
key_path = $(key_directory)/key_rsa
credentials_path = $(key_directory)/credentials
zhell_path = ~/.zshrc

.PHONY: install # = Install the barracuda-vpn
install:
	sudo dpkg -i $(barracuda_file)
	./vpn-configure

.PHONY: credentials # = Create the credentials file using a new key
credentials:
	@ if [ "$(user)" = "" ] || [ "$(pwd)" = "" ]; then \
        echo "Missing parameters! Use 'make test user=value pwd=value'"; \
        exit 1; \
    fi
	mkdir -p $(key_directory)
	openssl genrsa -out $(key_path) 2048
	echo "$(user)::$(pwd)" | openssl rsautl -inkey $(key_path) -encrypt > $(credentials_path)
	sudo chown root:root $(key_path)
	sudo chmod 400 $(key_path)
	sudo chmod 400 $(credentials_path)

.PHONY: show-credentials # = Decrypt and show the content of the credentials file
show-credentials:
	sudo openssl rsautl -inkey $(key_path) -decrypt < $(credentials_path)

.PHONY: test # = Connect to the vpn and close the connection
test:
	./vpn-open $(key_path) $(credentials_path)
	./vpn-close

.PHONY: clean # = Remove the encrypted files for credentials and the key
clean:
	sudo rm $(credentials_path) || true
	sudo rm $(key_path) || true
	rmdir --ignore-fail-on-non-empty $(key_directory)

.PHONY: zshell-configuration # = Create alias vpn and add this directory to PATH in the zshell
zshell-configuration:
	echo "" >> $(zhell_path)
	echo "" >> $(zhell_path)
	echo "# Used to automate barracuda-vpn" >> $(zhell_path)
	echo "alias vpn=\"vpn-open $(key_path) $(credentials_path)\"" >> $(zhell_path)
	echo "export PATH=\44PATH:$(PWD)" >> $(zhell_path)
	echo "# Used to automate barracuda-vpn" >> $(zhell_path)

.PHONY: help # = Generate list of targets with descriptions
help:
	@grep '^.PHONY: .* #' Makefile | sed 's/\.PHONY: \(.*\) # \(.*\)/\1 \2/' | expand -t20