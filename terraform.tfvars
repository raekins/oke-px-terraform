# Oracle Cloud Infrastructure Authentication details
tenancy_ocid        = "ocid1.tenancy.oc1..aaaaaaaaju7ze6knb4dudikjzsp6xzwvalyqxh2s3fttisjzfe5ha4akhsyq"
user_ocid           = "ocid1.user.oc1..aaaaaaaaavkigrezbgr5goiqmtsidtgy2gdrtvi4ffgl6lf4jpb6za7frtnq"
private_key_path    = "~/.oci/oci_api_key.pem"
fingerprint         = "4a:7f:93:70:8a:a4:9f:d1:c3:51:4b:3c:a2:8f:6a:ae"
region              = "uk-london-1"
ssh_public_key      = "~/.ssh/id_rsa.pub"
ssh_private_key     = "~/.ssh/id_rsa"

# Compartment
compartment_ocid    = "ocid1.compartment.oc1..aaaaaaaauktztjuam57uhird7up5gxp32svboo6bmjfxvotkja75tfndc2sq" # tf compartment
#compartment_ocid    = "ocid1.compartment.oc1..aaaaaaaapjkin3444dvpqqp3f6qttlebee6qyig5da62dt2qa7mdasgilz7a" # oke compartment

# Compute Instance
#source_ocid         = "ocid1.image.oc1.uk-london-1.aaaaaaaaoq3wgpdbk3zs657uywafkhwqy32vkdl6etzlhpfbtvf5j4jnugfa"  # Oracle Linux 8.4
#source_ocid         = "ocid1.image.oc1.uk-london-1.aaaaaaaaxdpy4ydhk6scrcq3fsueyp3zxfgtn6rcyw22ziddhyiwb3l43oja" # Oracle Linux 7.9  
source_ocid         = "ocid1.image.oc1.uk-london-1.aaaaaaaat2c3qn53nzxyry27noufp7iujsihgghlyoytyfjxsiv4kwwfoy6a" # Oracle Linux 7.8 
#source_ocid         = "ocid1.image.oc1.uk-london-1.aaaaaaaaahbkgd2yhw7yg6io76mbuwwtuk4monzpsr3r7nuiegttu5q75r6q" # Oracle Linux 7.6 

# Container Engine
cluster_name        = "pxcluster"
pool_name           = "pxpool"
kubernetes_version  = "v1.20.11"
VCN-name            = "pxvcn"

# Portworx
px_oper_url         = "https://install.portworx.com/2.8?comp=pxoperator"
px_spec_url         = "https://install.portworx.com/2.8?operator=true&mc=false&kbver=&b=true&c=px-cluster-5ad151aa-784e-4103-9ab5-a3529b18c12f&stork=true&csi=true&mon=true&tel=false&st=k8s&promop=true"

#px_oper_url         = "https://install.portworx.com/2.9?comp=pxoperator"
#px_spec_url         = "https://install.portworx.com/2.9?operator=true&mc=false&kbver=&b=true&s=%2Fdev%2Foracleoci%2Foraclevdb&c=px-cluster-0e066515-7550-4dec-9ff7-b56a05091df6&stork=true&csi=true&mon=true&tel=false&st=k8s&promop=true"
