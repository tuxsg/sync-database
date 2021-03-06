/*
 * Copyright (c) 2012 Citrix Systems, Inc.
 * 
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 */

create or replace package sync_admin as
    type varchar2_list is
        table of varchar2(2048) index by pls_integer;

    function add_device(
        device_name in varchar2,
        repo_uuid   in varchar2,
        config      in varchar2_list
    ) return varchar2;

    function add_disk(
        disk_name      in varchar2,
        file_path      in varchar2,
        file_size      in number,
        file_hash      in varchar2,
        encryption_key in varchar2,
        shared         in boolean
    ) return varchar2;

    function add_repo(
        release   in varchar2,
        build     in varchar2,
        file_path in varchar2,
        file_size in number,
        file_hash in varchar2
    ) return varchar2;

    function add_user(
        -- FIXME: check schema still makes sense
        user_name  in varchar2,
        auth_token in varchar2
    ) return varchar2;

    procedure add_user_to_device(
        user_uuid   in varchar2,
        device_uuid in varchar2
    );

    function add_vm(
        vm_name    in varchar2,
        disk_uuids in varchar2_list,
        config     in varchar2_list
    ) return varchar2;

    function add_vm_instance(
        device_uuid      in varchar2,
        user_uuid        in varchar2,
        vm_uuid          in varchar2,
        vm_instance_name in varchar2
    ) return varchar2;

    function complete_device_uuid(
        partial_device_uuid in varchar2
    ) return sys_refcursor;

    function complete_disk_uuid(
        partial_disk_uuid in varchar2
    ) return sys_refcursor;

    function complete_repo_uuid(
        partial_repo_uuid in varchar2
    ) return sys_refcursor;

    function complete_user_uuid(
        partial_user_uuid in varchar2,
        include_unremoved in boolean,
        include_removed   in boolean
    ) return sys_refcursor;

    function complete_vm_uuid(
        partial_vm_uuid in varchar2
    ) return sys_refcursor;

    function complete_vm_instance_uuid(
        partial_vm_instance_uuid in varchar2,
        include_unremoved        in boolean,
        include_removed          in boolean
    ) return sys_refcursor;

    function get_device(
        device_uuid in varchar2
    ) return sys_refcursor;

    function get_device_config(
        device_uuid in varchar2
    ) return sys_refcursor;

    function get_device_secret(
        device_uuid in varchar2
    ) return varchar2;

    function get_disk(
        disk_uuid in varchar2
    ) return sys_refcursor;

    function get_disk_key(
        disk_uuid in varchar2
    ) return varchar2;

    function get_repo(
        repo_uuid in varchar2
    ) return sys_refcursor;

    function get_report(
        device_uuid in varchar2
    ) return sys_refcursor;

    function get_user(
        user_uuid in varchar2
    ) return sys_refcursor;

    function get_vm(
        vm_uuid in varchar2
    ) return sys_refcursor;

    function get_vm_config(
        vm_uuid in varchar2
    ) return sys_refcursor;

    function get_vm_instance(
        vm_instance_uuid in varchar2
    ) return sys_refcursor;

    procedure list_all_files(
        disks out sys_refcursor,
        repos out sys_refcursor
    );

    function list_devices(
        device_name in varchar2,
        repo_uuid   in varchar2,
        no_repo     in boolean,
        user_uuid   in varchar2,
        vm_uuid     in varchar2
    ) return sys_refcursor;

    function list_disks(
        disk_name        in varchar2,
        file_path        in varchar2,
        file_hash        in varchar2,
        vm_uuid          in varchar2,
        vm_instance_uuid in varchar2,
        unused           in boolean
    ) return sys_refcursor;

    function list_repos(
        release   in varchar2,
        build     in varchar2,
        file_path in varchar2,
        file_hash in varchar2,
        unused    in boolean
    ) return sys_refcursor;

    function list_users(
        user_name   in varchar2,
        auth_token  in varchar2,
        device_uuid in varchar2,
        vm_uuid     in varchar2,
        removed     in boolean
    ) return sys_refcursor;

    function list_vms(
        vm_name     in varchar2,
        device_uuid in varchar2,
        disk_uuid   in varchar2,
        user_uuid   in varchar2,
        unused      in boolean
    ) return sys_refcursor;

    function list_vm_instances(
        vm_instance_name in varchar2,
        device_uuid      in varchar2,
        user_uuid        in varchar2,
        vm_uuid          in varchar2,
        disk_uuid        in varchar2,
        removed          in boolean
    ) return sys_refcursor;

    procedure lock_vm_instance(
        vm_instance_uuid in varchar2
    );

    procedure modify_device_config(
        device_uuid in varchar2,
        config      in varchar2_list,
        replace     in boolean
    );

    procedure modify_device_repo(
        device_uuid in varchar2,
        repo_uuid   in varchar2
    );

    procedure purge_user(
        user_uuid in varchar2,
        cascade   in boolean
    );

    procedure purge_user_from_device(
        user_uuid   in varchar2,
        device_uuid in varchar2,
        cascade     in boolean
    );

    procedure purge_vm_instance(
        vm_instance_uuid in varchar2
    );

    procedure readd_user(
        user_uuid in varchar2
    );

    procedure readd_user_to_device(
        user_uuid   in varchar2,
        device_uuid in varchar2
    );

    procedure readd_vm_instance(
        vm_instance_uuid in varchar2
    );

    procedure remove_device(
        device_uuid in varchar2,
        cascade     in boolean
    );

    procedure remove_disk(
        disk_uuid in varchar2
    );

    procedure remove_repo(
        repo_uuid in varchar2
    );

    procedure remove_user(
        user_uuid in varchar2,
        cascade   in boolean
    );

    procedure remove_user_from_device(
        user_uuid   in varchar2,
        device_uuid in varchar2,
        cascade     in boolean
    );

    procedure remove_vm(
        vm_uuid in varchar2
    );

    procedure remove_vm_instance(
        vm_instance_uuid in varchar2
    );

    procedure reset_device_secret(
        device_uuid in varchar2
    );

    procedure unlock_vm_instance(
        vm_instance_uuid in varchar2
    );

    procedure verify_database(
        device_user_errors out sys_refcursor,
        vm_instance_errors out sys_refcursor
    );
end;
/
