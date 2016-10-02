import os
import os.path
from os.path import basename
from urllib import urlopen
from urlparse import urlparse
import subprocess
from subprocess import Popen, PIPE
import urllib
import shutil
import glob
# custom Lisa module
import clusterfunc


def get_data(thefile):
    count = 0
    url_data = {}
    with open(thefile, "rU") as inputfile:
        headerline = next(inputfile).split(',')
        # print headerline
        position_name = headerline.index("ScientificName")
        position_reads = headerline.index("Run")
        position_ftp = headerline.index("download_path")
        position_mmetsp = headerline.index("SampleName")
	for line in inputfile:
            	line_data = line.split(',')
            	name = "_".join(line_data[position_name].split())
            	read_type = line_data[position_reads]
            	mmetsp = line_data[position_mmetsp]
		ftp = line_data[position_ftp]
            	name_read_tuple = (name, read_type, mmetsp)
            	print name_read_tuple
            	# check to see if Scientific Name and run exist
            	if name_read_tuple in url_data.keys():
                	if ftp in url_data[name_read_tuple]:
                    		print "url already exists:", ftp
                	else:
            	        	url_data[name_read_tuple].append(ftp)
            	else:
                	url_data[name_read_tuple] = [ftp]
        return url_data

def check_empty(empty_files, file, sra):
    if os.stat(file).st_size == 0:
        print "File is empty:", file
        if sra not in empty_files:
            empty_files.append(sra)
    return empty_files


def check_trinity(assemblies,trinity_fail, trinity_file, sra):
    if os.path.isfile(trinity_file):
        print "Trinity completed successfully:", trinity_file
	assemblies.append(sra)
    else:
        print "Trinity needs to be run again:", trinity_file
        trinity_fail.append(sra)
    return trinity_fail,assemblies


def send_to_cluster(newdir,command_list,sra,names):
	commands = []
	for string in command_list:
		commands.append(string)
    		process_name = names
    		module_name_list = ""
    		filename = sra
    		clusterfunc.qsub_file(newdir, process_name,
                          module_name_list, filename, commands)

def copy_files(trimdir,sra):
        tmp_trimdir = trimdir + "qsub_files/"
        file1 = tmp_trimdir+sra+".trim_1P.fq"
        file2 = tmp_trimdir+sra+".trim_2P.fq"
        mv_string1 = "cp "+file1+" "+trimdir
        mv_string2 = "cp "+file2+" "+trimdir
        return mv_string1,mv_string2

def move_files(url_data,basedir,newdir):
	for item in url_data:
                organism = item[0].replace("'","")
                sra = item[1]
                mmetsp = item[2]
		if mmetsp.endswith("_2"):
			mmetsp = mmetsp.split("_")[0]
		org_seq_dir = basedir + organism + "/"
		mmetsp_dir = newdir + mmetsp + "/"
	        print mmetsp_dir
		clusterfunc.check_dir(mmetsp_dir)

basedir = "/mnt/scratch/ljcohen/mmetsp_sra/"
newdir = "/mnt/scratch/ljcohen/mmetsp/"
clusterfunc.check_dir(newdir)
datafile = "../SraRunInfo_719.csv"
url_data = get_data(datafile)
print url_data
print len(url_data)
move_files(url_data,basedir,newdir)