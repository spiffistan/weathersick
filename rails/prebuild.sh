#!/bin/sh
set -e
cat >~/.ssh/id_rsa <<EOF
-----BEGIN RSA PRIVATE KEY-----
MIIEowIBAAKCAQEAzdAa+u9PByIeRJdKZILhXfraNtzbXPrF8MFlYiv4t+7Fan/o
5reUFWpNEANg0RDP+E/DoLReXOCg+9NBrkoxJEyfu20pDKPr06zfULBzdk25p99+
1dH4FNZEJXA48CzLa7czwYao6gXi6iy99fNDUVss3gz9wAGE8PJs+NuaGrEMcLjE
xS/CVDxEozdI1pBy7nSeVfEu3E4UOpvSG7PglzKsvEaHDmTRPch34Tvoudq5kvV4
b7YC+5IA5eN86SKaBXrXOQEifG2ic4ce9fOVy++8a8xur0xjf1by0vW1vnDke8cA
z1WRzTU3RVB2tmmKA8XgsVPc7NJ9t/H4v0zv3wIDAQABAoIBAHPw0vIfk75p+vEa
5T6f+ENQCFO1sSG853sMB4f5S2Cacr3fFp26NwKlYootzQGZXf79ODA0y5+4rxeN
18dOZkaTn7we72v+f+A714WGEVVIzdiC79mWMhHS7orEoF60bVfd2Zsgt9E1xbGz
yMNf6cFQAoOIf/4FHRX7C2ZZl4OGzNNT9lub0sJJygv2OIparyvFUFUNgbRO45lf
++g7bwv4JJ3uLwiROMLf4zmb3irdYe9v+SIhwtII/YMsWfCLMMTIXi4rlc04oBs7
GG1a6YZOBiWk9JzpUEBjbfsB1xRGT3T6ivcjHFO4EfEQvmmpQoXIsakuIhox8SEU
2OI4WnECgYEA6tGAYrnNHw+55zXDSfzsqsmj0h0ZJvSb7qZRzDnX+RkYpWhP6kcU
UyFaY3XriwcjJw2kdf8BBMzTx+AYrWDOCKktc/dXMYWgUbyeYW35qK8XIcv0NHCw
1+qnXUEe6NYpndXUvOnRCfKZu7Hbzn9T5CJB8m8TUMcH75VsLe2UQBkCgYEA4GDN
C5mb/nwjQSixVochHnMK8kYaXTk3SgCTLsVpt/FTBBNMHC/7nfHgvAGImmTmGDfn
oMlfwmCdSfYkle6Eavk731hsVP1i7hlGXe8+UzOwrmcaKX4hor4lpgrFX9qdlGJo
gYBVtVtO9BNprVYvrypV9FyW2q5SxfmZBVCXzrcCgYBk7sxqo0bCFTZpZbidsvPf
rXCXPh6zmez0tdTvHeXxkpH/d0jygL8BxJJfsi4ewmCfxsNsXMIJWCmn/nFdBQFK
w71f3W9DQBbbS2Igqu7nTOt6gXpkmBPLm3d5JCavGm8lAubAlRhfWEIwZZD/v8dF
hlwmYwxAamzE1Mt9KmPQ8QKBgQCL61FyPmQMmhTR+TI9Jx78Afl9g0HFiHx15U3j
CLAYSKDgFbiMi094+vCNzNcGkIz75UDH/0t7xwvOp3PBG2/v1WQErvs/NJOQrqo2
wY44DC/NUfX6kfEfrzuDA4x5bbZ+Za+Nsh3AbiQaCFEKCojJzrizHVnlHHf5hOBr
dAp2mQKBgE1Rltm+TfzKcfPRt5xXGIpzBxgXLMNYAm7RoXJC4L4hhmB1Wvj6Y1LN
CbX4lViQI5WLH2hU87bDNapZeagUbPPQIpg30MVPZJNLYgJenhnzymJ/3Gv08eTC
SLOqQJ5iWcZFgvO/DjCQBuF5vn/JN6Jhj6LdK2QKw3E+y0O3cvc4
-----END RSA PRIVATE KEY-----
EOF
chmod 0600 ~/.ssh/id_rsa
eval `ssh-agent -s`
ssh-add ~/.ssh/id_rsa
sleep 2
git clone ssh://git@github.com/spiffistan/weathersick-rails public

