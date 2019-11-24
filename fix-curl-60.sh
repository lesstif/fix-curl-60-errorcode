#!/bin/bash 

function is_root_user {
    if [ "$EUID" -ne 0 ];then
        echo "Please '$0' run as root";
        exit 1;
    fi
}

function  usage {
   echo "USAGE: $0 param..";
   exit 0;
}

function get_cert_path {
    if [ -x "/usr/bin/curl-config" ]; then
        /usr/bin/curl-config --ca;
    else
        curl --cacert non_existing_file https://www.google.com
    fi;

    exit 0;
}

PARAM="go:";
CA_CERT="";

while getopts $PARAM opt; do
  case $opt in
    g)
		get_cert_path;
        ;;
    o)
        is_root_user;
        CA_CERT=$OPTARG;
        ;;
    h)
        usage;
         ;;
    *)
         ## default
         usage;
         exit 1;
         
  esac
done

##
## see https://serverfault.com/questions/590870/how-to-view-all-ssl-certificates-in-a-bundle
openssl crl2pkcs7 -nocrl -certfile ${CA_CERT} | openssl pkcs7 -print_certs -text -noout

## downlaod bundle.pem
curl -k -O https://curl.haxx.se/ca/cacert.pem
