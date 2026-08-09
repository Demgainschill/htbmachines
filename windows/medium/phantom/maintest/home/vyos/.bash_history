#1720285262
ls
#1720285276
cat /etc/vyos/
#1720285291
cd /etc/vyos/
#1720285292
ls
#1720285293
cd
#1720285295
cd /etc/
#1720285295
ls
#1720285298
cd /opt/vyatta/etc/
#1720285299
ls
#1720285300
cd config
#1720285302
cd
#1720285320
ls
#1720285322
ls
#1720285331
ls
#1720285355
configure 
#1720285262
ls
#1720285276
cat /etc/vyos/
#1720285291
cd /etc/vyos/
#1720285292
ls
#1720285293
cd
#1720285295
cd /etc/
#1720285295
ls
#1720285298
cd /opt/vyatta/etc/
#1720285299
ls
#1720285300
cd config
#1720285302
cd
#1720285320
ls
#1720285322
ls
#1720285331
ls
#1720285355
configure 
#1720285375
set interfaces ethernet eth0 description 'OUTSIDE'
#1720285380
show interfaces 
#1720285397
set firewall global-options state-policy established action accept
#1720285397
set firewall global-options state-policy related action accept
#1720285398
set firewall global-options state-policy invalid action drop
#1720285401
set firewall ipv4 name CONN_FILTER default-action 'return'
#1720285401
set firewall ipv4 name CONN_FILTER rule 10 action 'accept'
#1720285402
set firewall ipv4 name CONN_FILTER rule 10 state established
#1720285402
set firewall ipv4 name CONN_FILTER rule 10 state related
#1720285402
set firewall ipv4 name CONN_FILTER rule 20 action 'drop'
#1720285402
set firewall ipv4 name CONN_FILTER rule 20 state invalid
#1720285406
set firewall ipv4 forward filter rule 10 action 'jump'
#1720285406
set firewall ipv4 forward filter rule 10 jump-target CONN_FILTER
#1720285406
set firewall ipv4 input filter rule 10 action 'jump'
#1720285406
set firewall ipv4 input filter rule 10 jump-target CONN_FILTER
#1720285413
set firewall ipv4 forward filter rule 5 action 'accept'
#1720285413
set firewall ipv4 forward filter rule 5 state established
#1720285413
set firewall ipv4 forward filter rule 5 state related
#1720285413
set firewall ipv4 forward filter rule 10 action 'drop'
#1720285413
set firewall ipv4 forward filter rule 10 state invalid
#1720285413
set firewall ipv4 input filter rule 5 action 'accept'
#1720285413
set firewall ipv4 input filter rule 5 state established
#1720285413
set firewall ipv4 input filter rule 5 state related
#1720285414
set firewall ipv4 input filter rule 10 action 'drop'
#1720285414
set firewall ipv4 input filter rule 10 state invalid
#1720285426
commit
#1720285449
set firewall ipv4 forward filter rule 10 action 'jump'
#1720285449
set firewall ipv4 forward filter rule 10 jump-target CONN_FILTER
#1720285449
set firewall ipv4 input filter rule 10 action 'jump'
#1720285449
set firewall ipv4 input filter rule 10 jump-target CONN_FILTER
#1720285455
commit
#1720285458
save
#1720285472
set firewall ipv4 name PHANTOM_MANAGEMENT default-action 'return'
#1720285472
set firewall ipv4 input filter rule 20 action jump
#1720285472
set firewall ipv4 input filter rule 20 jump-target PHANTOM_MANAGEMENT
#1720285472
set firewall ipv4 input filter rule 20 destination port 22
#1720285473
set firewall ipv4 input filter rule 20 protocol tcp
#1720285475
commit
#1720285480
exit
#1720285511
generate pki ca install CA
#1720285553
configure 
#1720285262
ls
#1720285276
cat /etc/vyos/
#1720285291
cd /etc/vyos/
#1720285292
ls
#1720285293
cd
#1720285295
cd /etc/
#1720285295
ls
#1720285298
cd /opt/vyatta/etc/
#1720285299
ls
#1720285300
cd config
#1720285302
cd
#1720285320
ls
#1720285322
ls
#1720285331
ls
#1720285355
configure 
#1720285262
ls
#1720285276
cat /etc/vyos/
#1720285291
cd /etc/vyos/
#1720285292
ls
#1720285293
cd
#1720285295
cd /etc/
#1720285295
ls
#1720285298
cd /opt/vyatta/etc/
#1720285299
ls
#1720285300
cd config
#1720285302
cd
#1720285320
ls
#1720285322
ls
#1720285331
ls
#1720285355
configure 
#1720285375
set interfaces ethernet eth0 description 'OUTSIDE'
#1720285380
show interfaces 
#1720285397
set firewall global-options state-policy established action accept
#1720285397
set firewall global-options state-policy related action accept
#1720285398
set firewall global-options state-policy invalid action drop
#1720285401
set firewall ipv4 name CONN_FILTER default-action 'return'
#1720285401
set firewall ipv4 name CONN_FILTER rule 10 action 'accept'
#1720285402
set firewall ipv4 name CONN_FILTER rule 10 state established
#1720285402
set firewall ipv4 name CONN_FILTER rule 10 state related
#1720285402
set firewall ipv4 name CONN_FILTER rule 20 action 'drop'
#1720285402
set firewall ipv4 name CONN_FILTER rule 20 state invalid
#1720285406
set firewall ipv4 forward filter rule 10 action 'jump'
#1720285406
set firewall ipv4 forward filter rule 10 jump-target CONN_FILTER
#1720285406
set firewall ipv4 input filter rule 10 action 'jump'
#1720285406
set firewall ipv4 input filter rule 10 jump-target CONN_FILTER
#1720285413
set firewall ipv4 forward filter rule 5 action 'accept'
#1720285413
set firewall ipv4 forward filter rule 5 state established
#1720285413
set firewall ipv4 forward filter rule 5 state related
#1720285413
set firewall ipv4 forward filter rule 10 action 'drop'
#1720285413
set firewall ipv4 forward filter rule 10 state invalid
#1720285413
set firewall ipv4 input filter rule 5 action 'accept'
#1720285413
set firewall ipv4 input filter rule 5 state established
#1720285413
set firewall ipv4 input filter rule 5 state related
#1720285414
set firewall ipv4 input filter rule 10 action 'drop'
#1720285414
set firewall ipv4 input filter rule 10 state invalid
#1720285426
commit
#1720285449
set firewall ipv4 forward filter rule 10 action 'jump'
#1720285449
set firewall ipv4 forward filter rule 10 jump-target CONN_FILTER
#1720285449
set firewall ipv4 input filter rule 10 action 'jump'
#1720285449
set firewall ipv4 input filter rule 10 jump-target CONN_FILTER
#1720285455
commit
#1720285458
save
#1720285472
set firewall ipv4 name PHANTOM_MANAGEMENT default-action 'return'
#1720285472
set firewall ipv4 input filter rule 20 action jump
#1720285472
set firewall ipv4 input filter rule 20 jump-target PHANTOM_MANAGEMENT
#1720285472
set firewall ipv4 input filter rule 20 destination port 22
#1720285473
set firewall ipv4 input filter rule 20 protocol tcp
#1720285475
commit
#1720285480
exit
#1720285511
generate pki ca install CA
#1720285553
configure 
#1720285554
set pki ca CA certificate 'MIIDpzCCAo+gAwIBAgIUMCKqCfhWNbQOBCBM51sI+5GykuAwDQYJKoZIhvcNAQELBQAwXDELMAkGA1UEBhMCR0IxEjAQBgNVBAgMCUFNT05HTEFORDESMBAGA1UEBwwJQU1PTkdDSVRZMRAwDgYDVQQKDAdQSEFOVE9NMRMwEQYDVQQDDApQSEFOVE9NLlZMMB4XDTI0MDcwNjE3MDU0NFoXDTI5MDcwNTE3MDU0NFowXDELMAkGA1UEBhMCR0IxEjAQBgNVBAgMCUFNT05HTEFORDESMBAGA1UEBwwJQU1PTkdDSVRZMRAwDgYDVQQKDAdQSEFOVE9NMRMwEQYDVQQDDApQSEFOVE9NLlZMMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAkLwTvauR+eiNZBp4+HvFzPH0/Js/JiLtuMoDEACSsn3Bo8w1wfORR1eCSI0AJfpDtu1mWqj4h4IUH1Y3+qkji4tJMvekCUoYPITP1UM42akBvRhbPelnYI8yKEfKtb/aQHI9SMLUtJT7LHuA/V1O4xpp9Bhc8wOQJ5j2pJJqAerdaTrCDcnkq/gZuf9m9FMBhnx26pna+jh2eszsd7RFVMKW3zp1jzbA/3XkrE6rm/wsVWVdsfS2wm4RTE9PwZvacEa58vcRugYHTYZPQI8UJzfCVawicsN1P2+sca1X9T249T37oTzXxNlckqKICNIFuPGvwFCAVTeu/MKr2f1RjQIDAQABo2EwXzAPBgNVHRMBAf8EBTADAQH/MA4GA1UdDwEB/wQEAwIBhjAdBgNVHSUEFjAUBggrBgEFBQcDAgYIKwYBBQUHAwEwHQYDVR0OBBYEFOgBL73batwqGzVMyYsPts0nzK0vMA0GCSqGSIb3DQEBCwUAA4IBAQBlnfFPs6se89Px9XsEBddJC6MPwLcaQT1KO+emLur67RGgxbVF7b1cvONv+F9kaF+WT5RT1EdB9Kg7phikwC4qewQfpZpIOIymj0FDO2a6Y+SoHnM1zKW4TioA1DxmKwZZWsMLKeI/y1qbo9kB4o6yKjryKUWMrWI72M0eqz3Zv/MtUN3ngqz8Hav9eubb3/t0iHh1aZRaUSjYWRHzLVGWlMBpPBfW3OIvSSubdFlZpKqjXXksLJqvHkyZkEzN0Chg0RKivHqFeCSJrVml9QCdVrv2XG/MkzjPeAkqDPECF94gn5ombcCJEUhlxe5mUYahCnZPfQnRIjIH97CqpJ/I'
#1720285554
set pki ca CA private key 'MIIFLTBXBgkqhkiG9w0BBQ0wSjApBgkqhkiG9w0BBQwwHAQIgWHj+CgnGPoCAggAMAwGCCqGSIb3DQIJBQAwHQYJYIZIAWUDBAEqBBBbepDeTwTMFzMcRWDm1aiCBIIE0DP9gh1Fgd3Bcumf7CEM1/dof4sGq31zB4HVuIUjPIGlGgsiCydExjkQAhzKT3elpIKgZzlz/WXIN6b//2SrsPLVFD3O+mfwDdriyu5+9qY+Uq6BzfqtwvIdPChc3tCThw/5fTwP8EKBU8vr4JfcZm7ZN3AjXgsk/Ibff/PcKQBUoawtPbqtbEEpLE76ttECCyXg22QL5zZmm8i6NjdrU9DChiWYAX9RTeEEGKHub2fUDT6oh75Sh8/MlL55By2Fp5iFPOq8T4crLVb0x9DjCIQ3Ac4bzphw+8qPIxnrd0H5noqAbqDeb2ueqyA24UpF0kJDBjWLHf0k1BEXMXW3j2tygwk4sVfJZkcIvfFR5SpUfP44FIVi3aJPcsLiFinOxXkjNEiUiPW/xHCutPab4ZMuho0a8HzvdNh1V/GZN5VdbwUq+X5CNzR4zeumCulonLXYrCgOLpxZPy/FWcGi1A6ORxXMVz9an38vvQQdBx/WZ/wCkqRigEqDTuBMKV9K0Wsmge/IC5RhJZyP93OMvbKSc4HO2KoVJanum6RPo2hzlwZjdnOvU1uq8iqvlFdsqasxxCzNpvLtIaWT6Z6Oid4MI0AnWP4Tzk9KLCkondORIgQepWwxn5KshG7wU1sNWvbICDHKm8lcmBt6IeQw82RojNEm7JmqhPpNf3EcsHYVLZzz604Afk8GkK2+GjaLwRU9LRImcjv6272zDZqs4Hl107KzxefbvTR9rgsalGZOuoY2WxJATYdw7jxX48+EJvPw18HxWl1Ig8+vcyFik1wWIlyehO0Gd0wewnPCzqX9t1zYjXiaLfWrh8pF4QjVfm7MWCVbDkk2rzS0dA8IB+JmhSNtt/OkFuuqdHH5DSv2JWvUs1NiTsTK6dIikNz4Mp697vcZ4UDNbLsadbTLlY2oyrI/UDU0SFyJM4IXKZNJOUqEcPxbHRagVsfu0J7vTqClo7PbRI0YMelHtoFZbJO4dh9ysP5ezc1T1E0/VFzDFAX/kbkWzEWcLFtMLqEqy5E8/I+/tuelFt6ouWBEw3WexAkS+TJ6SoapgmIg+BlirREySp0+kJFdA+SCsPysyR+Mze6qmXLifTlDvm7OytXYpz7eoy2igoy93pTVSTe9RjjD6jd0fvkxFSJuNx2utq/5rE74v5iszIAmc7HF5nnRzbhNN6DGtt+kotoYfEWnNtsf0djib0E+66XoweR5wanjsN5nTtPBO/3vML7iNHBHkpKXCG/uOXf10xu2Ht0aS3al5BuyxPNea/pTzUdH0inAss1QK/n1U6rpCECi7pucJWfgIE6BSQ9va9DXQVXmE2QfTRIheB0LLRKiFE0sO2WRTctwCS/BtISQd1h6waGwXOpTVWrglxZEuVEduVchNqgOdIHXKN3lqmu6R2Ptbnl9TU/u8c0utcjcoejVGKL2x4GULzqD7u7BhirwIaz0m2gV3I5IV+u9m96sRYhGpgtyh4v+MWDes9RKY3llr442pUk35tT/7m3mlPqaFvwgNlPssqSAHyaCcSaa8hHxxrNVDISh5hCcpSyhRq4Kp7UryvbrBtp89mt0c3+ARoJTExX2V8SsiCMHAxXcTdblIjTteqhWkrOLm6L4/alrIsyBGolLDBV0BUunam35EB5M'
#1720285560
exit
#1720285563
commit
#1720285566
save
#1720285567
exit
#1720285571
generate pki certificate sign CA install Server
#1720285589
generate pki certificate sign CA install Server
#1720285618
configure 
#1720285262
ls
#1720285276
cat /etc/vyos/
#1720285291
cd /etc/vyos/
#1720285292
ls
#1720285293
cd
#1720285295
cd /etc/
#1720285295
ls
#1720285298
cd /opt/vyatta/etc/
#1720285299
ls
#1720285300
cd config
#1720285302
cd
#1720285320
ls
#1720285322
ls
#1720285331
ls
#1720285355
configure 
#1720285262
ls
#1720285276
cat /etc/vyos/
#1720285291
cd /etc/vyos/
#1720285292
ls
#1720285293
cd
#1720285295
cd /etc/
#1720285295
ls
#1720285298
cd /opt/vyatta/etc/
#1720285299
ls
#1720285300
cd config
#1720285302
cd
#1720285320
ls
#1720285322
ls
#1720285331
ls
#1720285355
configure 
#1720285375
set interfaces ethernet eth0 description 'OUTSIDE'
#1720285380
show interfaces 
#1720285397
set firewall global-options state-policy established action accept
#1720285397
set firewall global-options state-policy related action accept
#1720285398
set firewall global-options state-policy invalid action drop
#1720285401
set firewall ipv4 name CONN_FILTER default-action 'return'
#1720285401
set firewall ipv4 name CONN_FILTER rule 10 action 'accept'
#1720285402
set firewall ipv4 name CONN_FILTER rule 10 state established
#1720285402
set firewall ipv4 name CONN_FILTER rule 10 state related
#1720285402
set firewall ipv4 name CONN_FILTER rule 20 action 'drop'
#1720285402
set firewall ipv4 name CONN_FILTER rule 20 state invalid
#1720285406
set firewall ipv4 forward filter rule 10 action 'jump'
#1720285406
set firewall ipv4 forward filter rule 10 jump-target CONN_FILTER
#1720285406
set firewall ipv4 input filter rule 10 action 'jump'
#1720285406
set firewall ipv4 input filter rule 10 jump-target CONN_FILTER
#1720285413
set firewall ipv4 forward filter rule 5 action 'accept'
#1720285413
set firewall ipv4 forward filter rule 5 state established
#1720285413
set firewall ipv4 forward filter rule 5 state related
#1720285413
set firewall ipv4 forward filter rule 10 action 'drop'
#1720285413
set firewall ipv4 forward filter rule 10 state invalid
#1720285413
set firewall ipv4 input filter rule 5 action 'accept'
#1720285413
set firewall ipv4 input filter rule 5 state established
#1720285413
set firewall ipv4 input filter rule 5 state related
#1720285414
set firewall ipv4 input filter rule 10 action 'drop'
#1720285414
set firewall ipv4 input filter rule 10 state invalid
#1720285426
commit
#1720285449
set firewall ipv4 forward filter rule 10 action 'jump'
#1720285449
set firewall ipv4 forward filter rule 10 jump-target CONN_FILTER
#1720285449
set firewall ipv4 input filter rule 10 action 'jump'
#1720285449
set firewall ipv4 input filter rule 10 jump-target CONN_FILTER
#1720285455
commit
#1720285458
save
#1720285472
set firewall ipv4 name PHANTOM_MANAGEMENT default-action 'return'
#1720285472
set firewall ipv4 input filter rule 20 action jump
#1720285472
set firewall ipv4 input filter rule 20 jump-target PHANTOM_MANAGEMENT
#1720285472
set firewall ipv4 input filter rule 20 destination port 22
#1720285473
set firewall ipv4 input filter rule 20 protocol tcp
#1720285475
commit
#1720285480
exit
#1720285511
generate pki ca install CA
#1720285553
configure 
#1720285262
ls
#1720285276
cat /etc/vyos/
#1720285291
cd /etc/vyos/
#1720285292
ls
#1720285293
cd
#1720285295
cd /etc/
#1720285295
ls
#1720285298
cd /opt/vyatta/etc/
#1720285299
ls
#1720285300
cd config
#1720285302
cd
#1720285320
ls
#1720285322
ls
#1720285331
ls
#1720285355
configure 
#1720285262
ls
#1720285276
cat /etc/vyos/
#1720285291
cd /etc/vyos/
#1720285292
ls
#1720285293
cd
#1720285295
cd /etc/
#1720285295
ls
#1720285298
cd /opt/vyatta/etc/
#1720285299
ls
#1720285300
cd config
#1720285302
cd
#1720285320
ls
#1720285322
ls
#1720285331
ls
#1720285355
configure 
#1720285375
set interfaces ethernet eth0 description 'OUTSIDE'
#1720285380
show interfaces 
#1720285397
set firewall global-options state-policy established action accept
#1720285397
set firewall global-options state-policy related action accept
#1720285398
set firewall global-options state-policy invalid action drop
#1720285401
set firewall ipv4 name CONN_FILTER default-action 'return'
#1720285401
set firewall ipv4 name CONN_FILTER rule 10 action 'accept'
#1720285402
set firewall ipv4 name CONN_FILTER rule 10 state established
#1720285402
set firewall ipv4 name CONN_FILTER rule 10 state related
#1720285402
set firewall ipv4 name CONN_FILTER rule 20 action 'drop'
#1720285402
set firewall ipv4 name CONN_FILTER rule 20 state invalid
#1720285406
set firewall ipv4 forward filter rule 10 action 'jump'
#1720285406
set firewall ipv4 forward filter rule 10 jump-target CONN_FILTER
#1720285406
set firewall ipv4 input filter rule 10 action 'jump'
#1720285406
set firewall ipv4 input filter rule 10 jump-target CONN_FILTER
#1720285413
set firewall ipv4 forward filter rule 5 action 'accept'
#1720285413
set firewall ipv4 forward filter rule 5 state established
#1720285413
set firewall ipv4 forward filter rule 5 state related
#1720285413
set firewall ipv4 forward filter rule 10 action 'drop'
#1720285413
set firewall ipv4 forward filter rule 10 state invalid
#1720285413
set firewall ipv4 input filter rule 5 action 'accept'
#1720285413
set firewall ipv4 input filter rule 5 state established
#1720285413
set firewall ipv4 input filter rule 5 state related
#1720285414
set firewall ipv4 input filter rule 10 action 'drop'
#1720285414
set firewall ipv4 input filter rule 10 state invalid
#1720285426
commit
#1720285449
set firewall ipv4 forward filter rule 10 action 'jump'
#1720285449
set firewall ipv4 forward filter rule 10 jump-target CONN_FILTER
#1720285449
set firewall ipv4 input filter rule 10 action 'jump'
#1720285449
set firewall ipv4 input filter rule 10 jump-target CONN_FILTER
#1720285455
commit
#1720285458
save
#1720285472
set firewall ipv4 name PHANTOM_MANAGEMENT default-action 'return'
#1720285472
set firewall ipv4 input filter rule 20 action jump
#1720285472
set firewall ipv4 input filter rule 20 jump-target PHANTOM_MANAGEMENT
#1720285472
set firewall ipv4 input filter rule 20 destination port 22
#1720285473
set firewall ipv4 input filter rule 20 protocol tcp
#1720285475
commit
#1720285480
exit
#1720285511
generate pki ca install CA
#1720285553
configure 
#1720285554
set pki ca CA certificate 'MIIDpzCCAo+gAwIBAgIUMCKqCfhWNbQOBCBM51sI+5GykuAwDQYJKoZIhvcNAQELBQAwXDELMAkGA1UEBhMCR0IxEjAQBgNVBAgMCUFNT05HTEFORDESMBAGA1UEBwwJQU1PTkdDSVRZMRAwDgYDVQQKDAdQSEFOVE9NMRMwEQYDVQQDDApQSEFOVE9NLlZMMB4XDTI0MDcwNjE3MDU0NFoXDTI5MDcwNTE3MDU0NFowXDELMAkGA1UEBhMCR0IxEjAQBgNVBAgMCUFNT05HTEFORDESMBAGA1UEBwwJQU1PTkdDSVRZMRAwDgYDVQQKDAdQSEFOVE9NMRMwEQYDVQQDDApQSEFOVE9NLlZMMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAkLwTvauR+eiNZBp4+HvFzPH0/Js/JiLtuMoDEACSsn3Bo8w1wfORR1eCSI0AJfpDtu1mWqj4h4IUH1Y3+qkji4tJMvekCUoYPITP1UM42akBvRhbPelnYI8yKEfKtb/aQHI9SMLUtJT7LHuA/V1O4xpp9Bhc8wOQJ5j2pJJqAerdaTrCDcnkq/gZuf9m9FMBhnx26pna+jh2eszsd7RFVMKW3zp1jzbA/3XkrE6rm/wsVWVdsfS2wm4RTE9PwZvacEa58vcRugYHTYZPQI8UJzfCVawicsN1P2+sca1X9T249T37oTzXxNlckqKICNIFuPGvwFCAVTeu/MKr2f1RjQIDAQABo2EwXzAPBgNVHRMBAf8EBTADAQH/MA4GA1UdDwEB/wQEAwIBhjAdBgNVHSUEFjAUBggrBgEFBQcDAgYIKwYBBQUHAwEwHQYDVR0OBBYEFOgBL73batwqGzVMyYsPts0nzK0vMA0GCSqGSIb3DQEBCwUAA4IBAQBlnfFPs6se89Px9XsEBddJC6MPwLcaQT1KO+emLur67RGgxbVF7b1cvONv+F9kaF+WT5RT1EdB9Kg7phikwC4qewQfpZpIOIymj0FDO2a6Y+SoHnM1zKW4TioA1DxmKwZZWsMLKeI/y1qbo9kB4o6yKjryKUWMrWI72M0eqz3Zv/MtUN3ngqz8Hav9eubb3/t0iHh1aZRaUSjYWRHzLVGWlMBpPBfW3OIvSSubdFlZpKqjXXksLJqvHkyZkEzN0Chg0RKivHqFeCSJrVml9QCdVrv2XG/MkzjPeAkqDPECF94gn5ombcCJEUhlxe5mUYahCnZPfQnRIjIH97CqpJ/I'
#1720285554
set pki ca CA private key 'MIIFLTBXBgkqhkiG9w0BBQ0wSjApBgkqhkiG9w0BBQwwHAQIgWHj+CgnGPoCAggAMAwGCCqGSIb3DQIJBQAwHQYJYIZIAWUDBAEqBBBbepDeTwTMFzMcRWDm1aiCBIIE0DP9gh1Fgd3Bcumf7CEM1/dof4sGq31zB4HVuIUjPIGlGgsiCydExjkQAhzKT3elpIKgZzlz/WXIN6b//2SrsPLVFD3O+mfwDdriyu5+9qY+Uq6BzfqtwvIdPChc3tCThw/5fTwP8EKBU8vr4JfcZm7ZN3AjXgsk/Ibff/PcKQBUoawtPbqtbEEpLE76ttECCyXg22QL5zZmm8i6NjdrU9DChiWYAX9RTeEEGKHub2fUDT6oh75Sh8/MlL55By2Fp5iFPOq8T4crLVb0x9DjCIQ3Ac4bzphw+8qPIxnrd0H5noqAbqDeb2ueqyA24UpF0kJDBjWLHf0k1BEXMXW3j2tygwk4sVfJZkcIvfFR5SpUfP44FIVi3aJPcsLiFinOxXkjNEiUiPW/xHCutPab4ZMuho0a8HzvdNh1V/GZN5VdbwUq+X5CNzR4zeumCulonLXYrCgOLpxZPy/FWcGi1A6ORxXMVz9an38vvQQdBx/WZ/wCkqRigEqDTuBMKV9K0Wsmge/IC5RhJZyP93OMvbKSc4HO2KoVJanum6RPo2hzlwZjdnOvU1uq8iqvlFdsqasxxCzNpvLtIaWT6Z6Oid4MI0AnWP4Tzk9KLCkondORIgQepWwxn5KshG7wU1sNWvbICDHKm8lcmBt6IeQw82RojNEm7JmqhPpNf3EcsHYVLZzz604Afk8GkK2+GjaLwRU9LRImcjv6272zDZqs4Hl107KzxefbvTR9rgsalGZOuoY2WxJATYdw7jxX48+EJvPw18HxWl1Ig8+vcyFik1wWIlyehO0Gd0wewnPCzqX9t1zYjXiaLfWrh8pF4QjVfm7MWCVbDkk2rzS0dA8IB+JmhSNtt/OkFuuqdHH5DSv2JWvUs1NiTsTK6dIikNz4Mp697vcZ4UDNbLsadbTLlY2oyrI/UDU0SFyJM4IXKZNJOUqEcPxbHRagVsfu0J7vTqClo7PbRI0YMelHtoFZbJO4dh9ysP5ezc1T1E0/VFzDFAX/kbkWzEWcLFtMLqEqy5E8/I+/tuelFt6ouWBEw3WexAkS+TJ6SoapgmIg+BlirREySp0+kJFdA+SCsPysyR+Mze6qmXLifTlDvm7OytXYpz7eoy2igoy93pTVSTe9RjjD6jd0fvkxFSJuNx2utq/5rE74v5iszIAmc7HF5nnRzbhNN6DGtt+kotoYfEWnNtsf0djib0E+66XoweR5wanjsN5nTtPBO/3vML7iNHBHkpKXCG/uOXf10xu2Ht0aS3al5BuyxPNea/pTzUdH0inAss1QK/n1U6rpCECi7pucJWfgIE6BSQ9va9DXQVXmE2QfTRIheB0LLRKiFE0sO2WRTctwCS/BtISQd1h6waGwXOpTVWrglxZEuVEduVchNqgOdIHXKN3lqmu6R2Ptbnl9TU/u8c0utcjcoejVGKL2x4GULzqD7u7BhirwIaz0m2gV3I5IV+u9m96sRYhGpgtyh4v+MWDes9RKY3llr442pUk35tT/7m3mlPqaFvwgNlPssqSAHyaCcSaa8hHxxrNVDISh5hCcpSyhRq4Kp7UryvbrBtp89mt0c3+ARoJTExX2V8SsiCMHAxXcTdblIjTteqhWkrOLm6L4/alrIsyBGolLDBV0BUunam35EB5M'
#1720285560
exit
#1720285563
commit
#1720285566
save
#1720285567
exit
#1720285571
generate pki certificate sign CA install Server
#1720285589
generate pki certificate sign CA install Server
#1720285618
configure 
#1720285619
set pki certificate Server certificate 'MIIDuzCCAqOgAwIBAgIUKEZTRk1Hj/2RxpsrK+jB0AZgwIcwDQYJKoZIhvcNAQELBQAwXDELMAkGA1UEBhMCR0IxEjAQBgNVBAgMCUFNT05HTEFORDESMBAGA1UEBwwJQU1PTkdDSVRZMRAwDgYDVQQKDAdQSEFOVE9NMRMwEQYDVQQDDApQSEFOVE9NLlZMMB4XDTI0MDcwNjE3MDY0OVoXDTI1MDcwNjE3MDY0OVowXDELMAkGA1UEBhMCR0IxEjAQBgNVBAgMCUFNT05HTEFORDESMBAGA1UEBwwJQU1PTkdDSVRZMRAwDgYDVQQKDAdQSEFOVE9NMRMwEQYDVQQDDApQSEFOVE9NLlZMMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAzcsWtyF+CxSJyYlmzwXZw1YyKnAl6dUTBw6db5nH4sJD5Dw+/p1nc3RoqzRWzJZU9cPGQyCXfsyfd/YHtMeU+PsKpXdGZS3p2qkAMrE+igvd/EqpA1dXe/+eZuop4vnQ5YUhpZhsqIhNdJTTA9FX8q6qy6+jskJVNmp+ef7h2I/q18+Z0Y76mTMLx4R10UiNHa3uoYmFdYy7yC2WOccGYVTqecxTLajZnOaD95zqn3/FJvD5zgAYK2RAEBf+VIjLI2p5WHu+2QDWLEuMmGcAQ0eq7s7gnvrbIUGEXXtirnLqZL6l/7WZca1yj1W413gBzEJzigiakM47oNfHIBHd4QIDAQABo3UwczAMBgNVHRMBAf8EAjAAMA4GA1UdDwEB/wQEAwIHgDATBgNVHSUEDDAKBggrBgEFBQcDATAdBgNVHQ4EFgQU+MLTOyNApvx6U+QYG50veWyfQnswHwYDVR0jBBgwFoAU6AEvvdtq3CobNUzJiw+2zSfMrS8wDQYJKoZIhvcNAQELBQADggEBAFlweIdOcTvyTDr/ZHWTPtgPafysDZRlaj1lSN1iGLfeCpR070KS0prBtKvQlQYsesFi8UN22B8mK1gphTNwUaFN7ntalZTLS04XjOEb7XiSkmgN/DlFAFE1hm4kOt/TRXPcTAQxQ8dEl3vLXqxoccJgpq7JwQ6tb18IOqd5STMMbzz41o8HTuoPy7aKday/jyYIj3q5pK3DGAO7t0qgwaapFnJ6Xn1PY52LNYJ8XkrUBCPK04ahvGW6RBCxFfOz04LLX6OkMpI/2Dl2FbLvAqqTm2k5xGd14XZD/ld3cHWEZ43N2WkeuwRJSShDtKgrx2Ogf9zrKVIkb5CFveOjPpk='
#1720285619
set pki certificate Server private key 'MIIFLTBXBgkqhkiG9w0BBQ0wSjApBgkqhkiG9w0BBQwwHAQIzKoz/D7mdgICAggAMAwGCCqGSIb3DQIJBQAwHQYJYIZIAWUDBAEqBBB3puT2PzgEkFcmTHdT1sdWBIIE0AkngnnzNTiv0wFBNekRzQeBkxqKGjGnyTMomUvkDCdmFCzH+DEzB6WKT3wKKKyAQ32MI9sGzHUoQeywNwxhX8sOUkVdWyH9mWUn8XTHh8VhelLvdns2eMFroVKcOcZ74AtWvz0WyX4E4RefAzAj3qrDLu5xpKawC/8ee8d0HpGW7SBXH+DuHo1/lBkDQl9T5s5JVEF0Pjt/52BAPpfmPMeFheDpYf7spm5Rmo9j/UFJBEAJUKwotdrPV04nNUZVlGW1VXzUOd/bsrj06zj++LfsxQSl3IXfOPOjcNNFdN3fGFtF+Auo8LyMk5SHxlvGFGoGfKAbDPoxDYkf0UGsNvs0hCPIEfpfNr6N769pvooRI3zQcpRmh6kdda7+a+WSw5re7lJT23N4GxXePnxGoJQ3cuJZK2PefCf04Wo5pse4eQTrcV446tjU2d7ejCrqJAt65ytJB08Sd7b8UvH/ZqkJwG5c5PKnXyUvDy+DW6UuYh0AOORMySkMsr61wB49PHZqU9vBff9eW+sxqHL1rrWbdLwPJtavqxt/5UowZUtG6sO7NkBx3AgX8DQQOrTcCW7HK/9FLnphAWRiWHaeE0BkYY/3fRL5W7i+eAGsGNqJuXBUa3WmQM1hAc32QCkWUDMBVn6aaBU8h8EVfDzPCZeMHjrOWrjhoAG/r7ifeJzpof6q4mgmNAwHCis06TlrYB+LHiXjo8x1LaoR/cztu8kqODtRoWQhlWZAzaTdh1GanvKtu2xJ94SpbYddAdrkMiASF3izY8ka6f+Wab1Y2bfMdNnktIy7DV7Px6jss6/YHlm9+3JqfemphaTpvwq1CtjfyZrRNTq87b66OJpJ29rG13r5oQHs0B4CrlN0ds5PaCeVp+A71lPucu3PbHtp5LcFbNNf67x5XlpyBAPV7E+AavZOfdbazVlWqDgT2IQlvDDdXDK0SnlF7Aft5Rniv0RFZPliwgauv5idwpdPIO7MLRFxEY0mrWaJJhvXrGdvM37879inlusKhz+cC90cgnon6FZ6lRQxShAvo7NlamOL8YXccrfFP+UJgixMunvsCUP15s0c9Il/o88vKMhUCecJhYDEgjvJUtCBik+0T4yuQEGSRKDKxv3dr4oTmdokyD/6uaULnLOXqb8QXzXnaOogSw1c/oR8TspMYsqTzMZ4T5vXrMKZCDmcf9+SkRSUo3bmTxC7sK8mhPfdndY2lU5cZQWKqcs2WyCrahLoCQbMqN5uwVdQyjhhYVeMN8hOlg0aNx814idKR0/PjbBLU9Ml5NZAKDTSDKC+B5ZwPjrP72tyfkxQyGFb69b7iaBRh97UQid/pRef6RWg5ZaIp15GPpEjVrdJHbBaDqS1RIYg61iiMohVCAfDIja5E/Q9gqhN6a5FabK+8IXh2Zmz2iYm+mlUlBZh3DIr3u9Bx0xHcrEtn+lheqI3K+pjcJbttQu0++rqcbgyfihvRwhyDF0qPxL9vuzr6DjU5EaRBS4A2bWe226w93tOAsNwRhg/RqxkHlwIvFz6aXfTh6qY2G8GsC9vPyb0m1zQYtAEIkMvL9hqDdRV9TUz4/64bAvZ1SewktUSmWVdLQ1ULjlt7AYNdga+kE+9FKMOJ+mQIm9WNQOVZIWvCYU5fjTTLO5Y'
#1720285623
commit
#1720285626
save
#1720285635
exit
#1720285637
ls
#1720285650
set vpn sstp authentication mode 'local'
#1720285650
set vpn sstp client-ip-pool SSTP-POOL range '10.0.0.2-10.0.0.100'
#1720285650
set vpn sstp default-pool 'SSTP-POOL'
#1720285650
set vpn sstp gateway-address '10.0.0.1'
#1720285650
set vpn sstp ssl ca-certificate 'CA'
#1720285650
set vpn sstp ssl certificate 'Server'
#1720285654
configure 
#1720285262
ls
#1720285276
cat /etc/vyos/
#1720285291
cd /etc/vyos/
#1720285292
ls
#1720285293
cd
#1720285295
cd /etc/
#1720285295
ls
#1720285298
cd /opt/vyatta/etc/
#1720285299
ls
#1720285300
cd config
#1720285302
cd
#1720285320
ls
#1720285322
ls
#1720285331
ls
#1720285355
configure 
#1720285262
ls
#1720285276
cat /etc/vyos/
#1720285291
cd /etc/vyos/
#1720285292
ls
#1720285293
cd
#1720285295
cd /etc/
#1720285295
ls
#1720285298
cd /opt/vyatta/etc/
#1720285299
ls
#1720285300
cd config
#1720285302
cd
#1720285320
ls
#1720285322
ls
#1720285331
ls
#1720285355
configure 
#1720285375
set interfaces ethernet eth0 description 'OUTSIDE'
#1720285380
show interfaces 
#1720285397
set firewall global-options state-policy established action accept
#1720285397
set firewall global-options state-policy related action accept
#1720285398
set firewall global-options state-policy invalid action drop
#1720285401
set firewall ipv4 name CONN_FILTER default-action 'return'
#1720285401
set firewall ipv4 name CONN_FILTER rule 10 action 'accept'
#1720285402
set firewall ipv4 name CONN_FILTER rule 10 state established
#1720285402
set firewall ipv4 name CONN_FILTER rule 10 state related
#1720285402
set firewall ipv4 name CONN_FILTER rule 20 action 'drop'
#1720285402
set firewall ipv4 name CONN_FILTER rule 20 state invalid
#1720285406
set firewall ipv4 forward filter rule 10 action 'jump'
#1720285406
set firewall ipv4 forward filter rule 10 jump-target CONN_FILTER
#1720285406
set firewall ipv4 input filter rule 10 action 'jump'
#1720285406
set firewall ipv4 input filter rule 10 jump-target CONN_FILTER
#1720285413
set firewall ipv4 forward filter rule 5 action 'accept'
#1720285413
set firewall ipv4 forward filter rule 5 state established
#1720285413
set firewall ipv4 forward filter rule 5 state related
#1720285413
set firewall ipv4 forward filter rule 10 action 'drop'
#1720285413
set firewall ipv4 forward filter rule 10 state invalid
#1720285413
set firewall ipv4 input filter rule 5 action 'accept'
#1720285413
set firewall ipv4 input filter rule 5 state established
#1720285413
set firewall ipv4 input filter rule 5 state related
#1720285414
set firewall ipv4 input filter rule 10 action 'drop'
#1720285414
set firewall ipv4 input filter rule 10 state invalid
#1720285426
commit
#1720285449
set firewall ipv4 forward filter rule 10 action 'jump'
#1720285449
set firewall ipv4 forward filter rule 10 jump-target CONN_FILTER
#1720285449
set firewall ipv4 input filter rule 10 action 'jump'
#1720285449
set firewall ipv4 input filter rule 10 jump-target CONN_FILTER
#1720285455
commit
#1720285458
save
#1720285472
set firewall ipv4 name PHANTOM_MANAGEMENT default-action 'return'
#1720285472
set firewall ipv4 input filter rule 20 action jump
#1720285472
set firewall ipv4 input filter rule 20 jump-target PHANTOM_MANAGEMENT
#1720285472
set firewall ipv4 input filter rule 20 destination port 22
#1720285473
set firewall ipv4 input filter rule 20 protocol tcp
#1720285475
commit
#1720285480
exit
#1720285511
generate pki ca install CA
#1720285553
configure 
#1720285262
ls
#1720285276
cat /etc/vyos/
#1720285291
cd /etc/vyos/
#1720285292
ls
#1720285293
cd
#1720285295
cd /etc/
#1720285295
ls
#1720285298
cd /opt/vyatta/etc/
#1720285299
ls
#1720285300
cd config
#1720285302
cd
#1720285320
ls
#1720285322
ls
#1720285331
ls
#1720285355
configure 
#1720285262
ls
#1720285276
cat /etc/vyos/
#1720285291
cd /etc/vyos/
#1720285292
ls
#1720285293
cd
#1720285295
cd /etc/
#1720285295
ls
#1720285298
cd /opt/vyatta/etc/
#1720285299
ls
#1720285300
cd config
#1720285302
cd
#1720285320
ls
#1720285322
ls
#1720285331
ls
#1720285355
configure 
#1720285375
set interfaces ethernet eth0 description 'OUTSIDE'
#1720285380
show interfaces 
#1720285397
set firewall global-options state-policy established action accept
#1720285397
set firewall global-options state-policy related action accept
#1720285398
set firewall global-options state-policy invalid action drop
#1720285401
set firewall ipv4 name CONN_FILTER default-action 'return'
#1720285401
set firewall ipv4 name CONN_FILTER rule 10 action 'accept'
#1720285402
set firewall ipv4 name CONN_FILTER rule 10 state established
#1720285402
set firewall ipv4 name CONN_FILTER rule 10 state related
#1720285402
set firewall ipv4 name CONN_FILTER rule 20 action 'drop'
#1720285402
set firewall ipv4 name CONN_FILTER rule 20 state invalid
#1720285406
set firewall ipv4 forward filter rule 10 action 'jump'
#1720285406
set firewall ipv4 forward filter rule 10 jump-target CONN_FILTER
#1720285406
set firewall ipv4 input filter rule 10 action 'jump'
#1720285406
set firewall ipv4 input filter rule 10 jump-target CONN_FILTER
#1720285413
set firewall ipv4 forward filter rule 5 action 'accept'
#1720285413
set firewall ipv4 forward filter rule 5 state established
#1720285413
set firewall ipv4 forward filter rule 5 state related
#1720285413
set firewall ipv4 forward filter rule 10 action 'drop'
#1720285413
set firewall ipv4 forward filter rule 10 state invalid
#1720285413
set firewall ipv4 input filter rule 5 action 'accept'
#1720285413
set firewall ipv4 input filter rule 5 state established
#1720285413
set firewall ipv4 input filter rule 5 state related
#1720285414
set firewall ipv4 input filter rule 10 action 'drop'
#1720285414
set firewall ipv4 input filter rule 10 state invalid
#1720285426
commit
#1720285449
set firewall ipv4 forward filter rule 10 action 'jump'
#1720285449
set firewall ipv4 forward filter rule 10 jump-target CONN_FILTER
#1720285449
set firewall ipv4 input filter rule 10 action 'jump'
#1720285449
set firewall ipv4 input filter rule 10 jump-target CONN_FILTER
#1720285455
commit
#1720285458
save
#1720285472
set firewall ipv4 name PHANTOM_MANAGEMENT default-action 'return'
#1720285472
set firewall ipv4 input filter rule 20 action jump
#1720285472
set firewall ipv4 input filter rule 20 jump-target PHANTOM_MANAGEMENT
#1720285472
set firewall ipv4 input filter rule 20 destination port 22
#1720285473
set firewall ipv4 input filter rule 20 protocol tcp
#1720285475
commit
#1720285480
exit
#1720285511
generate pki ca install CA
#1720285553
configure 
#1720285554
set pki ca CA certificate 'MIIDpzCCAo+gAwIBAgIUMCKqCfhWNbQOBCBM51sI+5GykuAwDQYJKoZIhvcNAQELBQAwXDELMAkGA1UEBhMCR0IxEjAQBgNVBAgMCUFNT05HTEFORDESMBAGA1UEBwwJQU1PTkdDSVRZMRAwDgYDVQQKDAdQSEFOVE9NMRMwEQYDVQQDDApQSEFOVE9NLlZMMB4XDTI0MDcwNjE3MDU0NFoXDTI5MDcwNTE3MDU0NFowXDELMAkGA1UEBhMCR0IxEjAQBgNVBAgMCUFNT05HTEFORDESMBAGA1UEBwwJQU1PTkdDSVRZMRAwDgYDVQQKDAdQSEFOVE9NMRMwEQYDVQQDDApQSEFOVE9NLlZMMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAkLwTvauR+eiNZBp4+HvFzPH0/Js/JiLtuMoDEACSsn3Bo8w1wfORR1eCSI0AJfpDtu1mWqj4h4IUH1Y3+qkji4tJMvekCUoYPITP1UM42akBvRhbPelnYI8yKEfKtb/aQHI9SMLUtJT7LHuA/V1O4xpp9Bhc8wOQJ5j2pJJqAerdaTrCDcnkq/gZuf9m9FMBhnx26pna+jh2eszsd7RFVMKW3zp1jzbA/3XkrE6rm/wsVWVdsfS2wm4RTE9PwZvacEa58vcRugYHTYZPQI8UJzfCVawicsN1P2+sca1X9T249T37oTzXxNlckqKICNIFuPGvwFCAVTeu/MKr2f1RjQIDAQABo2EwXzAPBgNVHRMBAf8EBTADAQH/MA4GA1UdDwEB/wQEAwIBhjAdBgNVHSUEFjAUBggrBgEFBQcDAgYIKwYBBQUHAwEwHQYDVR0OBBYEFOgBL73batwqGzVMyYsPts0nzK0vMA0GCSqGSIb3DQEBCwUAA4IBAQBlnfFPs6se89Px9XsEBddJC6MPwLcaQT1KO+emLur67RGgxbVF7b1cvONv+F9kaF+WT5RT1EdB9Kg7phikwC4qewQfpZpIOIymj0FDO2a6Y+SoHnM1zKW4TioA1DxmKwZZWsMLKeI/y1qbo9kB4o6yKjryKUWMrWI72M0eqz3Zv/MtUN3ngqz8Hav9eubb3/t0iHh1aZRaUSjYWRHzLVGWlMBpPBfW3OIvSSubdFlZpKqjXXksLJqvHkyZkEzN0Chg0RKivHqFeCSJrVml9QCdVrv2XG/MkzjPeAkqDPECF94gn5ombcCJEUhlxe5mUYahCnZPfQnRIjIH97CqpJ/I'
#1720285554
set pki ca CA private key 'MIIFLTBXBgkqhkiG9w0BBQ0wSjApBgkqhkiG9w0BBQwwHAQIgWHj+CgnGPoCAggAMAwGCCqGSIb3DQIJBQAwHQYJYIZIAWUDBAEqBBBbepDeTwTMFzMcRWDm1aiCBIIE0DP9gh1Fgd3Bcumf7CEM1/dof4sGq31zB4HVuIUjPIGlGgsiCydExjkQAhzKT3elpIKgZzlz/WXIN6b//2SrsPLVFD3O+mfwDdriyu5+9qY+Uq6BzfqtwvIdPChc3tCThw/5fTwP8EKBU8vr4JfcZm7ZN3AjXgsk/Ibff/PcKQBUoawtPbqtbEEpLE76ttECCyXg22QL5zZmm8i6NjdrU9DChiWYAX9RTeEEGKHub2fUDT6oh75Sh8/MlL55By2Fp5iFPOq8T4crLVb0x9DjCIQ3Ac4bzphw+8qPIxnrd0H5noqAbqDeb2ueqyA24UpF0kJDBjWLHf0k1BEXMXW3j2tygwk4sVfJZkcIvfFR5SpUfP44FIVi3aJPcsLiFinOxXkjNEiUiPW/xHCutPab4ZMuho0a8HzvdNh1V/GZN5VdbwUq+X5CNzR4zeumCulonLXYrCgOLpxZPy/FWcGi1A6ORxXMVz9an38vvQQdBx/WZ/wCkqRigEqDTuBMKV9K0Wsmge/IC5RhJZyP93OMvbKSc4HO2KoVJanum6RPo2hzlwZjdnOvU1uq8iqvlFdsqasxxCzNpvLtIaWT6Z6Oid4MI0AnWP4Tzk9KLCkondORIgQepWwxn5KshG7wU1sNWvbICDHKm8lcmBt6IeQw82RojNEm7JmqhPpNf3EcsHYVLZzz604Afk8GkK2+GjaLwRU9LRImcjv6272zDZqs4Hl107KzxefbvTR9rgsalGZOuoY2WxJATYdw7jxX48+EJvPw18HxWl1Ig8+vcyFik1wWIlyehO0Gd0wewnPCzqX9t1zYjXiaLfWrh8pF4QjVfm7MWCVbDkk2rzS0dA8IB+JmhSNtt/OkFuuqdHH5DSv2JWvUs1NiTsTK6dIikNz4Mp697vcZ4UDNbLsadbTLlY2oyrI/UDU0SFyJM4IXKZNJOUqEcPxbHRagVsfu0J7vTqClo7PbRI0YMelHtoFZbJO4dh9ysP5ezc1T1E0/VFzDFAX/kbkWzEWcLFtMLqEqy5E8/I+/tuelFt6ouWBEw3WexAkS+TJ6SoapgmIg+BlirREySp0+kJFdA+SCsPysyR+Mze6qmXLifTlDvm7OytXYpz7eoy2igoy93pTVSTe9RjjD6jd0fvkxFSJuNx2utq/5rE74v5iszIAmc7HF5nnRzbhNN6DGtt+kotoYfEWnNtsf0djib0E+66XoweR5wanjsN5nTtPBO/3vML7iNHBHkpKXCG/uOXf10xu2Ht0aS3al5BuyxPNea/pTzUdH0inAss1QK/n1U6rpCECi7pucJWfgIE6BSQ9va9DXQVXmE2QfTRIheB0LLRKiFE0sO2WRTctwCS/BtISQd1h6waGwXOpTVWrglxZEuVEduVchNqgOdIHXKN3lqmu6R2Ptbnl9TU/u8c0utcjcoejVGKL2x4GULzqD7u7BhirwIaz0m2gV3I5IV+u9m96sRYhGpgtyh4v+MWDes9RKY3llr442pUk35tT/7m3mlPqaFvwgNlPssqSAHyaCcSaa8hHxxrNVDISh5hCcpSyhRq4Kp7UryvbrBtp89mt0c3+ARoJTExX2V8SsiCMHAxXcTdblIjTteqhWkrOLm6L4/alrIsyBGolLDBV0BUunam35EB5M'
#1720285560
exit
#1720285563
commit
#1720285566
save
#1720285567
exit
#1720285571
generate pki certificate sign CA install Server
#1720285589
generate pki certificate sign CA install Server
#1720285618
configure 
#1720285262
ls
#1720285276
cat /etc/vyos/
#1720285291
cd /etc/vyos/
#1720285292
ls
#1720285293
cd
#1720285295
cd /etc/
#1720285295
ls
#1720285298
cd /opt/vyatta/etc/
#1720285299
ls
#1720285300
cd config
#1720285302
cd
#1720285320
ls
#1720285322
ls
#1720285331
ls
#1720285355
configure 
#1720285262
ls
#1720285276
cat /etc/vyos/
#1720285291
cd /etc/vyos/
#1720285292
ls
#1720285293
cd
#1720285295
cd /etc/
#1720285295
ls
#1720285298
cd /opt/vyatta/etc/
#1720285299
ls
#1720285300
cd config
#1720285302
cd
#1720285320
ls
#1720285322
ls
#1720285331
ls
#1720285355
configure 
#1720285375
set interfaces ethernet eth0 description 'OUTSIDE'
#1720285380
show interfaces 
#1720285397
set firewall global-options state-policy established action accept
#1720285397
set firewall global-options state-policy related action accept
#1720285398
set firewall global-options state-policy invalid action drop
#1720285401
set firewall ipv4 name CONN_FILTER default-action 'return'
#1720285401
set firewall ipv4 name CONN_FILTER rule 10 action 'accept'
#1720285402
set firewall ipv4 name CONN_FILTER rule 10 state established
#1720285402
set firewall ipv4 name CONN_FILTER rule 10 state related
#1720285402
set firewall ipv4 name CONN_FILTER rule 20 action 'drop'
#1720285402
set firewall ipv4 name CONN_FILTER rule 20 state invalid
#1720285406
set firewall ipv4 forward filter rule 10 action 'jump'
#1720285406
set firewall ipv4 forward filter rule 10 jump-target CONN_FILTER
#1720285406
set firewall ipv4 input filter rule 10 action 'jump'
#1720285406
set firewall ipv4 input filter rule 10 jump-target CONN_FILTER
#1720285413
set firewall ipv4 forward filter rule 5 action 'accept'
#1720285413
set firewall ipv4 forward filter rule 5 state established
#1720285413
set firewall ipv4 forward filter rule 5 state related
#1720285413
set firewall ipv4 forward filter rule 10 action 'drop'
#1720285413
set firewall ipv4 forward filter rule 10 state invalid
#1720285413
set firewall ipv4 input filter rule 5 action 'accept'
#1720285413
set firewall ipv4 input filter rule 5 state established
#1720285413
set firewall ipv4 input filter rule 5 state related
#1720285414
set firewall ipv4 input filter rule 10 action 'drop'
#1720285414
set firewall ipv4 input filter rule 10 state invalid
#1720285426
commit
#1720285449
set firewall ipv4 forward filter rule 10 action 'jump'
#1720285449
set firewall ipv4 forward filter rule 10 jump-target CONN_FILTER
#1720285449
set firewall ipv4 input filter rule 10 action 'jump'
#1720285449
set firewall ipv4 input filter rule 10 jump-target CONN_FILTER
#1720285455
commit
#1720285458
save
#1720285472
set firewall ipv4 name PHANTOM_MANAGEMENT default-action 'return'
#1720285472
set firewall ipv4 input filter rule 20 action jump
#1720285472
set firewall ipv4 input filter rule 20 jump-target PHANTOM_MANAGEMENT
#1720285472
set firewall ipv4 input filter rule 20 destination port 22
#1720285473
set firewall ipv4 input filter rule 20 protocol tcp
#1720285475
commit
#1720285480
exit
#1720285511
generate pki ca install CA
#1720285553
configure 
#1720285262
ls
#1720285276
cat /etc/vyos/
#1720285291
cd /etc/vyos/
#1720285292
ls
#1720285293
cd
#1720285295
cd /etc/
#1720285295
ls
#1720285298
cd /opt/vyatta/etc/
#1720285299
ls
#1720285300
cd config
#1720285302
cd
#1720285320
ls
#1720285322
ls
#1720285331
ls
#1720285355
configure 
#1720285262
ls
#1720285276
cat /etc/vyos/
#1720285291
cd /etc/vyos/
#1720285292
ls
#1720285293
cd
#1720285295
cd /etc/
#1720285295
ls
#1720285298
cd /opt/vyatta/etc/
#1720285299
ls
#1720285300
cd config
#1720285302
cd
#1720285320
ls
#1720285322
ls
#1720285331
ls
#1720285355
configure 
#1720285375
set interfaces ethernet eth0 description 'OUTSIDE'
#1720285380
show interfaces 
#1720285397
set firewall global-options state-policy established action accept
#1720285397
set firewall global-options state-policy related action accept
#1720285398
set firewall global-options state-policy invalid action drop
#1720285401
set firewall ipv4 name CONN_FILTER default-action 'return'
#1720285401
set firewall ipv4 name CONN_FILTER rule 10 action 'accept'
#1720285402
set firewall ipv4 name CONN_FILTER rule 10 state established
#1720285402
set firewall ipv4 name CONN_FILTER rule 10 state related
#1720285402
set firewall ipv4 name CONN_FILTER rule 20 action 'drop'
#1720285402
set firewall ipv4 name CONN_FILTER rule 20 state invalid
#1720285406
set firewall ipv4 forward filter rule 10 action 'jump'
#1720285406
set firewall ipv4 forward filter rule 10 jump-target CONN_FILTER
#1720285406
set firewall ipv4 input filter rule 10 action 'jump'
#1720285406
set firewall ipv4 input filter rule 10 jump-target CONN_FILTER
#1720285413
set firewall ipv4 forward filter rule 5 action 'accept'
#1720285413
set firewall ipv4 forward filter rule 5 state established
#1720285413
set firewall ipv4 forward filter rule 5 state related
#1720285413
set firewall ipv4 forward filter rule 10 action 'drop'
#1720285413
set firewall ipv4 forward filter rule 10 state invalid
#1720285413
set firewall ipv4 input filter rule 5 action 'accept'
#1720285413
set firewall ipv4 input filter rule 5 state established
#1720285413
set firewall ipv4 input filter rule 5 state related
#1720285414
set firewall ipv4 input filter rule 10 action 'drop'
#1720285414
set firewall ipv4 input filter rule 10 state invalid
#1720285426
commit
#1720285449
set firewall ipv4 forward filter rule 10 action 'jump'
#1720285449
set firewall ipv4 forward filter rule 10 jump-target CONN_FILTER
#1720285449
set firewall ipv4 input filter rule 10 action 'jump'
#1720285449
set firewall ipv4 input filter rule 10 jump-target CONN_FILTER
#1720285455
commit
#1720285458
save
#1720285472
set firewall ipv4 name PHANTOM_MANAGEMENT default-action 'return'
#1720285472
set firewall ipv4 input filter rule 20 action jump
#1720285472
set firewall ipv4 input filter rule 20 jump-target PHANTOM_MANAGEMENT
#1720285472
set firewall ipv4 input filter rule 20 destination port 22
#1720285473
set firewall ipv4 input filter rule 20 protocol tcp
#1720285475
commit
#1720285480
exit
#1720285511
generate pki ca install CA
#1720285553
configure 
#1720285554
set pki ca CA certificate 'MIIDpzCCAo+gAwIBAgIUMCKqCfhWNbQOBCBM51sI+5GykuAwDQYJKoZIhvcNAQELBQAwXDELMAkGA1UEBhMCR0IxEjAQBgNVBAgMCUFNT05HTEFORDESMBAGA1UEBwwJQU1PTkdDSVRZMRAwDgYDVQQKDAdQSEFOVE9NMRMwEQYDVQQDDApQSEFOVE9NLlZMMB4XDTI0MDcwNjE3MDU0NFoXDTI5MDcwNTE3MDU0NFowXDELMAkGA1UEBhMCR0IxEjAQBgNVBAgMCUFNT05HTEFORDESMBAGA1UEBwwJQU1PTkdDSVRZMRAwDgYDVQQKDAdQSEFOVE9NMRMwEQYDVQQDDApQSEFOVE9NLlZMMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAkLwTvauR+eiNZBp4+HvFzPH0/Js/JiLtuMoDEACSsn3Bo8w1wfORR1eCSI0AJfpDtu1mWqj4h4IUH1Y3+qkji4tJMvekCUoYPITP1UM42akBvRhbPelnYI8yKEfKtb/aQHI9SMLUtJT7LHuA/V1O4xpp9Bhc8wOQJ5j2pJJqAerdaTrCDcnkq/gZuf9m9FMBhnx26pna+jh2eszsd7RFVMKW3zp1jzbA/3XkrE6rm/wsVWVdsfS2wm4RTE9PwZvacEa58vcRugYHTYZPQI8UJzfCVawicsN1P2+sca1X9T249T37oTzXxNlckqKICNIFuPGvwFCAVTeu/MKr2f1RjQIDAQABo2EwXzAPBgNVHRMBAf8EBTADAQH/MA4GA1UdDwEB/wQEAwIBhjAdBgNVHSUEFjAUBggrBgEFBQcDAgYIKwYBBQUHAwEwHQYDVR0OBBYEFOgBL73batwqGzVMyYsPts0nzK0vMA0GCSqGSIb3DQEBCwUAA4IBAQBlnfFPs6se89Px9XsEBddJC6MPwLcaQT1KO+emLur67RGgxbVF7b1cvONv+F9kaF+WT5RT1EdB9Kg7phikwC4qewQfpZpIOIymj0FDO2a6Y+SoHnM1zKW4TioA1DxmKwZZWsMLKeI/y1qbo9kB4o6yKjryKUWMrWI72M0eqz3Zv/MtUN3ngqz8Hav9eubb3/t0iHh1aZRaUSjYWRHzLVGWlMBpPBfW3OIvSSubdFlZpKqjXXksLJqvHkyZkEzN0Chg0RKivHqFeCSJrVml9QCdVrv2XG/MkzjPeAkqDPECF94gn5ombcCJEUhlxe5mUYahCnZPfQnRIjIH97CqpJ/I'
#1720285554
set pki ca CA private key 'MIIFLTBXBgkqhkiG9w0BBQ0wSjApBgkqhkiG9w0BBQwwHAQIgWHj+CgnGPoCAggAMAwGCCqGSIb3DQIJBQAwHQYJYIZIAWUDBAEqBBBbepDeTwTMFzMcRWDm1aiCBIIE0DP9gh1Fgd3Bcumf7CEM1/dof4sGq31zB4HVuIUjPIGlGgsiCydExjkQAhzKT3elpIKgZzlz/WXIN6b//2SrsPLVFD3O+mfwDdriyu5+9qY+Uq6BzfqtwvIdPChc3tCThw/5fTwP8EKBU8vr4JfcZm7ZN3AjXgsk/Ibff/PcKQBUoawtPbqtbEEpLE76ttECCyXg22QL5zZmm8i6NjdrU9DChiWYAX9RTeEEGKHub2fUDT6oh75Sh8/MlL55By2Fp5iFPOq8T4crLVb0x9DjCIQ3Ac4bzphw+8qPIxnrd0H5noqAbqDeb2ueqyA24UpF0kJDBjWLHf0k1BEXMXW3j2tygwk4sVfJZkcIvfFR5SpUfP44FIVi3aJPcsLiFinOxXkjNEiUiPW/xHCutPab4ZMuho0a8HzvdNh1V/GZN5VdbwUq+X5CNzR4zeumCulonLXYrCgOLpxZPy/FWcGi1A6ORxXMVz9an38vvQQdBx/WZ/wCkqRigEqDTuBMKV9K0Wsmge/IC5RhJZyP93OMvbKSc4HO2KoVJanum6RPo2hzlwZjdnOvU1uq8iqvlFdsqasxxCzNpvLtIaWT6Z6Oid4MI0AnWP4Tzk9KLCkondORIgQepWwxn5KshG7wU1sNWvbICDHKm8lcmBt6IeQw82RojNEm7JmqhPpNf3EcsHYVLZzz604Afk8GkK2+GjaLwRU9LRImcjv6272zDZqs4Hl107KzxefbvTR9rgsalGZOuoY2WxJATYdw7jxX48+EJvPw18HxWl1Ig8+vcyFik1wWIlyehO0Gd0wewnPCzqX9t1zYjXiaLfWrh8pF4QjVfm7MWCVbDkk2rzS0dA8IB+JmhSNtt/OkFuuqdHH5DSv2JWvUs1NiTsTK6dIikNz4Mp697vcZ4UDNbLsadbTLlY2oyrI/UDU0SFyJM4IXKZNJOUqEcPxbHRagVsfu0J7vTqClo7PbRI0YMelHtoFZbJO4dh9ysP5ezc1T1E0/VFzDFAX/kbkWzEWcLFtMLqEqy5E8/I+/tuelFt6ouWBEw3WexAkS+TJ6SoapgmIg+BlirREySp0+kJFdA+SCsPysyR+Mze6qmXLifTlDvm7OytXYpz7eoy2igoy93pTVSTe9RjjD6jd0fvkxFSJuNx2utq/5rE74v5iszIAmc7HF5nnRzbhNN6DGtt+kotoYfEWnNtsf0djib0E+66XoweR5wanjsN5nTtPBO/3vML7iNHBHkpKXCG/uOXf10xu2Ht0aS3al5BuyxPNea/pTzUdH0inAss1QK/n1U6rpCECi7pucJWfgIE6BSQ9va9DXQVXmE2QfTRIheB0LLRKiFE0sO2WRTctwCS/BtISQd1h6waGwXOpTVWrglxZEuVEduVchNqgOdIHXKN3lqmu6R2Ptbnl9TU/u8c0utcjcoejVGKL2x4GULzqD7u7BhirwIaz0m2gV3I5IV+u9m96sRYhGpgtyh4v+MWDes9RKY3llr442pUk35tT/7m3mlPqaFvwgNlPssqSAHyaCcSaa8hHxxrNVDISh5hCcpSyhRq4Kp7UryvbrBtp89mt0c3+ARoJTExX2V8SsiCMHAxXcTdblIjTteqhWkrOLm6L4/alrIsyBGolLDBV0BUunam35EB5M'
#1720285560
exit
#1720285563
commit
#1720285566
save
#1720285567
exit
#1720285571
generate pki certificate sign CA install Server
#1720285589
generate pki certificate sign CA install Server
#1720285618
configure 
#1720285619
set pki certificate Server certificate 'MIIDuzCCAqOgAwIBAgIUKEZTRk1Hj/2RxpsrK+jB0AZgwIcwDQYJKoZIhvcNAQELBQAwXDELMAkGA1UEBhMCR0IxEjAQBgNVBAgMCUFNT05HTEFORDESMBAGA1UEBwwJQU1PTkdDSVRZMRAwDgYDVQQKDAdQSEFOVE9NMRMwEQYDVQQDDApQSEFOVE9NLlZMMB4XDTI0MDcwNjE3MDY0OVoXDTI1MDcwNjE3MDY0OVowXDELMAkGA1UEBhMCR0IxEjAQBgNVBAgMCUFNT05HTEFORDESMBAGA1UEBwwJQU1PTkdDSVRZMRAwDgYDVQQKDAdQSEFOVE9NMRMwEQYDVQQDDApQSEFOVE9NLlZMMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAzcsWtyF+CxSJyYlmzwXZw1YyKnAl6dUTBw6db5nH4sJD5Dw+/p1nc3RoqzRWzJZU9cPGQyCXfsyfd/YHtMeU+PsKpXdGZS3p2qkAMrE+igvd/EqpA1dXe/+eZuop4vnQ5YUhpZhsqIhNdJTTA9FX8q6qy6+jskJVNmp+ef7h2I/q18+Z0Y76mTMLx4R10UiNHa3uoYmFdYy7yC2WOccGYVTqecxTLajZnOaD95zqn3/FJvD5zgAYK2RAEBf+VIjLI2p5WHu+2QDWLEuMmGcAQ0eq7s7gnvrbIUGEXXtirnLqZL6l/7WZca1yj1W413gBzEJzigiakM47oNfHIBHd4QIDAQABo3UwczAMBgNVHRMBAf8EAjAAMA4GA1UdDwEB/wQEAwIHgDATBgNVHSUEDDAKBggrBgEFBQcDATAdBgNVHQ4EFgQU+MLTOyNApvx6U+QYG50veWyfQnswHwYDVR0jBBgwFoAU6AEvvdtq3CobNUzJiw+2zSfMrS8wDQYJKoZIhvcNAQELBQADggEBAFlweIdOcTvyTDr/ZHWTPtgPafysDZRlaj1lSN1iGLfeCpR070KS0prBtKvQlQYsesFi8UN22B8mK1gphTNwUaFN7ntalZTLS04XjOEb7XiSkmgN/DlFAFE1hm4kOt/TRXPcTAQxQ8dEl3vLXqxoccJgpq7JwQ6tb18IOqd5STMMbzz41o8HTuoPy7aKday/jyYIj3q5pK3DGAO7t0qgwaapFnJ6Xn1PY52LNYJ8XkrUBCPK04ahvGW6RBCxFfOz04LLX6OkMpI/2Dl2FbLvAqqTm2k5xGd14XZD/ld3cHWEZ43N2WkeuwRJSShDtKgrx2Ogf9zrKVIkb5CFveOjPpk='
#1720285619
set pki certificate Server private key 'MIIFLTBXBgkqhkiG9w0BBQ0wSjApBgkqhkiG9w0BBQwwHAQIzKoz/D7mdgICAggAMAwGCCqGSIb3DQIJBQAwHQYJYIZIAWUDBAEqBBB3puT2PzgEkFcmTHdT1sdWBIIE0AkngnnzNTiv0wFBNekRzQeBkxqKGjGnyTMomUvkDCdmFCzH+DEzB6WKT3wKKKyAQ32MI9sGzHUoQeywNwxhX8sOUkVdWyH9mWUn8XTHh8VhelLvdns2eMFroVKcOcZ74AtWvz0WyX4E4RefAzAj3qrDLu5xpKawC/8ee8d0HpGW7SBXH+DuHo1/lBkDQl9T5s5JVEF0Pjt/52BAPpfmPMeFheDpYf7spm5Rmo9j/UFJBEAJUKwotdrPV04nNUZVlGW1VXzUOd/bsrj06zj++LfsxQSl3IXfOPOjcNNFdN3fGFtF+Auo8LyMk5SHxlvGFGoGfKAbDPoxDYkf0UGsNvs0hCPIEfpfNr6N769pvooRI3zQcpRmh6kdda7+a+WSw5re7lJT23N4GxXePnxGoJQ3cuJZK2PefCf04Wo5pse4eQTrcV446tjU2d7ejCrqJAt65ytJB08Sd7b8UvH/ZqkJwG5c5PKnXyUvDy+DW6UuYh0AOORMySkMsr61wB49PHZqU9vBff9eW+sxqHL1rrWbdLwPJtavqxt/5UowZUtG6sO7NkBx3AgX8DQQOrTcCW7HK/9FLnphAWRiWHaeE0BkYY/3fRL5W7i+eAGsGNqJuXBUa3WmQM1hAc32QCkWUDMBVn6aaBU8h8EVfDzPCZeMHjrOWrjhoAG/r7ifeJzpof6q4mgmNAwHCis06TlrYB+LHiXjo8x1LaoR/cztu8kqODtRoWQhlWZAzaTdh1GanvKtu2xJ94SpbYddAdrkMiASF3izY8ka6f+Wab1Y2bfMdNnktIy7DV7Px6jss6/YHlm9+3JqfemphaTpvwq1CtjfyZrRNTq87b66OJpJ29rG13r5oQHs0B4CrlN0ds5PaCeVp+A71lPucu3PbHtp5LcFbNNf67x5XlpyBAPV7E+AavZOfdbazVlWqDgT2IQlvDDdXDK0SnlF7Aft5Rniv0RFZPliwgauv5idwpdPIO7MLRFxEY0mrWaJJhvXrGdvM37879inlusKhz+cC90cgnon6FZ6lRQxShAvo7NlamOL8YXccrfFP+UJgixMunvsCUP15s0c9Il/o88vKMhUCecJhYDEgjvJUtCBik+0T4yuQEGSRKDKxv3dr4oTmdokyD/6uaULnLOXqb8QXzXnaOogSw1c/oR8TspMYsqTzMZ4T5vXrMKZCDmcf9+SkRSUo3bmTxC7sK8mhPfdndY2lU5cZQWKqcs2WyCrahLoCQbMqN5uwVdQyjhhYVeMN8hOlg0aNx814idKR0/PjbBLU9Ml5NZAKDTSDKC+B5ZwPjrP72tyfkxQyGFb69b7iaBRh97UQid/pRef6RWg5ZaIp15GPpEjVrdJHbBaDqS1RIYg61iiMohVCAfDIja5E/Q9gqhN6a5FabK+8IXh2Zmz2iYm+mlUlBZh3DIr3u9Bx0xHcrEtn+lheqI3K+pjcJbttQu0++rqcbgyfihvRwhyDF0qPxL9vuzr6DjU5EaRBS4A2bWe226w93tOAsNwRhg/RqxkHlwIvFz6aXfTh6qY2G8GsC9vPyb0m1zQYtAEIkMvL9hqDdRV9TUz4/64bAvZ1SewktUSmWVdLQ1ULjlt7AYNdga+kE+9FKMOJ+mQIm9WNQOVZIWvCYU5fjTTLO5Y'
#1720285623
commit
#1720285626
save
#1720285635
exit
#1720285637
ls
#1720285650
set vpn sstp authentication mode 'local'
#1720285650
set vpn sstp client-ip-pool SSTP-POOL range '10.0.0.2-10.0.0.100'
#1720285650
set vpn sstp default-pool 'SSTP-POOL'
#1720285650
set vpn sstp gateway-address '10.0.0.1'
#1720285650
set vpn sstp ssl ca-certificate 'CA'
#1720285650
set vpn sstp ssl certificate 'Server'
#1720285654
configure 
#1720285658
set vpn sstp authentication mode 'local'
#1720285658
set vpn sstp client-ip-pool SSTP-POOL range '10.0.0.2-10.0.0.100'
#1720285658
set vpn sstp default-pool 'SSTP-POOL'
#1720285658
set vpn sstp gateway-address '10.0.0.1'
#1720285658
set vpn sstp ssl ca-certificate 'CA'
#1720285659
set vpn sstp ssl certificate 'Server'
#1720285664
commit
#1720285667
save
#1720285670
exit
#1720285675
dd if=/dev/sda of=/tmp/vyos.img bs=4M
#1720285704
rm -rf /tmp/vyos.img 
#1720285967
dd if=/dev/sda | gzip -1 - | ssh user@local dd of=image.gz
#1720285993
dd if=/dev/sda | gzip -1 - | ssh arshia@192.168.1.25 dd of=image.gz
#1720286090
fdisk -l
#1720286120
ls
#1720286123
fdisk -l
#1720286131
dd if=/dev/sda3 | gzip -1 - | ssh arshia@192.168.1.25 dd of=image.gz
#1720286402
ls
#1720286403
ls
#1720286411
ls
#1720286424
cd /opt/vyatta/etc/config
#1720286425
ls
#1720286426
cat config.boot 
#1720286459
configure 
#1720286461
save
#1720286464
exit
#1720286464
exit
#1720286468
init 6
#1720286470
reboot 
#1720286528
cd /opt/vyatta/etc/config
#1720286529
ls
#1720286531
cat config.boot 
#1720286535
cd
#1720286544
fdisk -l
#1720286569
dd if=/dev/sda | gzip -1 - | ssh arshia@192.168.1.25 dd of=image.gz
#1720286677
sudi dd if=/dev/sda | gzip -1 - | ssh arshia@192.168.1.25 dd of=image.gz
#1720286681
sudo dd if=/dev/sda | gzip -1 - | ssh arshia@192.168.1.25 dd of=image.gz
#1720286996
dd if=/dev/sda3 | gzip -1 - | ssh arshia@192.168.1.25 dd of=image.gz
#1720287192
cd /opt/vyatta/etc/config
#1720287193
ls
#1720287394
fdisk -l
#1720287571
dd if=/dev/sda bs=512 status=progress | gzip -1 - | ssh arshia@192.168.1.25 dd of=image.gz
#1720287963
sudo sync
#1720287979
sudo dd if=/dev/sda bs=512 | gzip -1 - | ssh arshia@192.168.1.25 'dd of=/home/arshia/image.gz'
#1720288136
sudo dd if=/dev/sda bs=512 | gzip -1 - | ssh arshia@192.168.1.25 'dd of=/home/arshia/image.gz'
#1720288168
ls
#1720294383
sudo tar --exclude=/proc --exclude=/sys --exclude=/dev --exclude=/tmp/system_backup.tar.gz -cvpzf /tmp/system_backup.tar.gz /
#1720294485
ls
#1720294486
ls -la
#1720294488
cd /tmp/
#1720294488
ls
#1720294489
ls -la
#1720294493
ls -lh
#1720294504
rm -rf system_backup.tar.gz 
#1720294506
sudo rm -rf system_backup.tar.gz 
#1720294507
ls
#1720294532
ls -la
#1720294533
cd
#1720294534
ls
#1720294536
ls /
#1720294539
ls -la /
#1720294540
sudo tar --exclude=/proc --exclude=/sys --exclude=/dev --exclude=/tmp/system_backup.tar.gz -cvpzf /tmp/system_backup.tar.gz /
#1720294547
sudo rm -rf /tmp/system_backup.tar.gz 
#1720294578
sudo tar --exclude=/proc --exclude=/usr --exclude=/sys --exclude=/dev --exclude=/tmp/system_backup.tar.gz -cvpzf /tmp/system_backup.tar.gz /
#1720294588
ls
#1720294596
sudo rm /tmp/system_backup.tar.gz 
#1720294614
sudo tar --exclude=/proc --exclude=/boot --exclude=/usr --exclude=/sys --exclude=/dev --exclude=/tmp/system_backup.tar.gz -cvpzf /tmp/system_backup.tar.gz /
#1720294619
ls
#1720294630
ls -lh /tmp/system
#1720294632
ls -lh /tmp/system_backup.tar.gz 
#1720294721
scp /tmp/system_backup.tar.gz arshia@192.168.1.25:.
#1720294728
ls
#1720295104
date
#1720295110
date
#1720295112
sync
#1720295120
ls
#1720295121
ls
#1720295123
date
#1720295123
tiume
#1720295124
time
#1720295126
ls
#1720295128
cd /tmp/
#1720295128
ls
#1720295130
rm -rf system
#1720295135
rm -rf system_backup.tar.gz 
#1720295137
sudo rm -rf system_backup.tar.gz 
