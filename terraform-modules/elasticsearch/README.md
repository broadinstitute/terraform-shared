## Elasticsearch module

## Required Variables 


`owner`: A string for the owner, used in resource names

`service`: A string for the service name, used in resource names

`instance_labels`: In order for elasticsearch to work, you must specify `ansible_project` as an instance label. See Other Considerations

## Important Optional Variables

`num_hosts`: The number of instances. Default `3`

## Other Considerations

For a complete list of variables, see the `variables.tf` file.

This module relies on mounting a data disk, setting its permissions correctly, and updating the sysctl `vm.max_map_count` value to `262144`. We use Ansible to perform these functions. See the [terra env](https://github.com/broadinstitute/dsp-ansible-configs/blob/master/terra-env.yml#L7) [docker](https://github.com/broadinstitute/dsp-ansible-configs/blob/master/inventories/terra-env/group_vars/docker-ol2.yml#L12) and [elasticsearch-specific](https://github.com/broadinstitute/dsp-ansible-configs/blob/rl-set-fs-permissions/inventories/terra-env/group_vars/elasticsearch.yml) settings for reference.

```
module "elasticsearch" {                                                 
  source        = "github.com/broadinstitute/terraform-shared.git//terraform-modules/elasticsearch?ref=elasticsearch-0.0.0-tf-0.12"
                                                                         
  providers = {                                                          
    google.target =  "google",                                           
    google.dns =  "google.dns"                                           
  }                                                                      
  project                  = "${var.google_project}"                     
  owner                    = "${var.owner}"                              
  service                  = "${var.service}"                            
  instance_name            = "${var.service}"                            
  application_service_account  = "${var.config_reader_service_account}"
  dns_zone_name            = "${var.dns_zone_name}"                      
  instance_size            = "${var.instance_size}"                      
  instance_data_disk_size  = "${var.instance_data_disk_size}"            
  instance_data_disk_type  = "${var.instance_data_disk_type}"            
  instance_data_disk_name  = "${var.service}-data-disk"                  
  instance_network_name    = "${data.google_compute_network.terra-env-network.name}"
  instance_tags            = "${var.instance_tags}"                      
  instance_labels          = {                                           
    "app"             = "${var.service}",                                
    "owner"           = "${var.owner}",                                  
    "role"            = "db",                                            
    "ansible_branch"  = "master",                                        
    "ansible_project" = "terra-env",                                     
  }                                                                      
}
```


