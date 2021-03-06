#!/bin/bash

# Copyright 2015 VMware, Inc.
#
# All Rights Reserved
#
#    Licensed under the Apache License, Version 2.0 (the "License"); you may
#    not use this file except in compliance with the License. You may obtain
#    a copy of the License at
#
#         http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
#    WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
#    License for the specific language governing permissions and limitations
#    under the License.


dir=${GITDIR['vmware-nsx']}/devstack

if [[ "$1" == "stack" && "$2" == "install" ]]; then
    setup_develop ${GITDIR['vmware-nsx']}
fi

if [[ $Q_PLUGIN == 'vmware_nsx_v' ]]; then
    source $dir/lib/vmware_nsx_v
    if [[ "$1" == "unstack" ]]; then
        python $dir/tools/nsxv_cleanup.py --vsm-ip ${NSXV_MANAGER_URI/https:\/\/} --user $NSXV_USER --password $NSXV_PASSWORD
    fi
elif [[ $Q_PLUGIN == 'vmware_nsx' ]]; then
    source $dir/lib/vmware_nsx
    if [[ "$1" == "stack" && "$2" == "post-config" ]]; then
        init_vmware_nsx
    elif [[ "$1" == "stack" && "$2" == "extra" ]]; then
        check_vmware_nsx
    elif [[ "$1" == "unstack" ]]; then
        stop_vmware_nsx
    fi
elif [[ $Q_PLUGIN == 'vmware_nsx_v3' ]]; then
    source $dir/lib/vmware_nsx_v3
    if [[ "$1" == "stack" && "$2" == "post-config" ]]; then
        init_vmware_nsx_v3
    elif [[ "$1" == "unstack" ]]; then
        stop_vmware_nsx
        NSX_MANAGER=${NSX_MANAGERS:-$NSX_MANAGER}
        IFS=','
        NSX_MANAGER=($NSX_MANAGER)
        unset IFS
        python $dir/tools/nsxv3_cleanup.py --mgr-ip $NSX_MANAGER --user $NSX_USER --password $NSX_PASSWORD
    fi
elif [[ $Q_PLUGIN == 'vmware_dvs' ]]; then
    source $dir/lib/vmware_dvs
fi
