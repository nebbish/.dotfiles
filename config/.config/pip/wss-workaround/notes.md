
## Python versions:

    py -3 -m pip --version:  23.2.1
    py -3 --version:   3.7.9

## Command to export certificates from the MacOS Keychain

-- Root certificates:

    security export -t certs -f pemseq -k /System/Library/Keychains/SystemRootCertificates.keychain -o os-root-certs.pem

-- Self-signed certificates:

    security export -t certs -f pemseq -k /Library/Keychains/System.keychain -o os-self-certs.pem

-- Then join with the downloaded WSS cert:

    cat os-root-certs.pem os-self-certs.pem wss-intercept-ca.crt > all.pem

## Command to show current certification locations:

    py -3 -c "import ssl; print(ssl.get_default_verify_paths())"

    DefaultVerifyPaths(cafile=None, capath=None, openssl_cafile_env='SSL_CERT_FILE', openssl_cafile='/Library/Frameworks/Python.framework/Versions/3.7/etc/openssl/cert.pem', openssl_capath_env='SSL_CERT_DIR', openssl_capath='/Library/Frameworks/Python.framework/Versions/3.7/etc/openssl/certs')


        openssl_cafile_env='SSL_CERT_FILE', openssl_cafile='/Library/Frameworks/Python.framework/Versions/3.7/etc/openssl/cert.pem',
        openssl_capath_env='SSL_CERT_DIR',  openssl_capath='/Library/Frameworks/Python.framework/Versions/3.7/etc/openssl/certs'

-- Examine those locations:

    ls -la /Library/Frameworks/Python.framework/Versions/3.7/etc/openssl

# WSS certificate:

The wss-intercept-ca.crt certificate is used by the current protection to "intercept" SSL traffic coming into this machine.

Normally it is trusted because it "chains up" to the main certificate installed by the protection in the root store.
HOWEVER -- some tools do not yet follow the chain.  Python's PIP is one. :(

So in order to use the WSS protection *and* be able to install PIP modules, we are working around the issue by installing the actual cert used for interception as a trusted root cert.

    NOTE:  This cert was provided to me by ********* when I explained my problem in the help channel.  At that time, ********* also explained that this cert is NOT dropped by the product to be found somewhere on the HDD.


Without this work-around, `pip install ...` gets the following error every time:

    ssl.SSLCertVerificationError: [SSL: CERTIFICATE_VERIFY_FAILED] certificate verify failed: unable to get local issuer certificate (_ssl.c:1091)


## Copy the WSS cert into the location reported by Python:

The command `py -3 -c "import ssl; print(ssl.get_default_verify_paths())"` reports that "SSL_CERT_DIR"="/Library/Frameworks/Python.framework/Versions/3.7/etc/openssl/certs"

    sudo mkdir /Library/Frameworks/Python.framework/Versions/3.7/etc/openssl/certs
    sudo chmod 775 /Library/Frameworks/Python.framework/Versions/3.7/etc/openssl/certs
    cp wss-intercept-ca.crt /Library/Frameworks/Python.framework/Versions/3.7/etc/openssl/certs
    la /Library/Frameworks/Python.framework/Versions/3.7/etc/openssl/certs

cat bundleCA.pem selfSignedCAbundle.pem wss-intercept-ca.crt >> all.pem


# Debug loop:

    py -3 -m pip list --local

    py -3 -m pip uninstall -y wheel
    rm -rf $(py -3 -m pip cache dir)/http

    py -3 -m pip install wheel



