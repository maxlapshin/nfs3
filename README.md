NFS client driver
-----------------


This library is an implementation (partial) of access to NFS server from erlang without
any blocking kernel calls.

run

    make 
    ./nfs3.erl


This helper will show you what can current implementation do:

# full scan of remote directory (in a very efficient manner)
# read remote file
# write content to remote file
# delete remote file with recursive deletion of all empty containing directories

Will be implemented:

# read_file_info
# commit writing of file
# renaming files
# remote fs stats (disk usage)
# partial read

