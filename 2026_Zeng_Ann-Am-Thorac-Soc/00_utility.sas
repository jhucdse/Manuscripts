/**************************************************************************************
 * Progname: 00_utility.sas
 * Purpose: Configure SAS input, output, and format libraries
 * Date created: 2024-12-19
 * Author: Lijuan Zeng
 ***************************************************************************************/

libname indata "S:/lzeng3/ALA_SRMA/indata";
libname outdata "S:/lzeng3/ALA_SRMA/outdata";

libname format "S:/lzeng3/ALA_SRMA/format";

* Output directory;
%global outdir indir datacut;
%let indir=%str(S:/lzeng3/ALA_SRMA/indata);
%put indir=&indir.;

/* Keep the trailing slash: report filenames concatenate outdir and progname. */
%let outdir=%str(S:/lzeng3/ALA_SRMA/outdata/);
%put outdir=&outdir.;

%let datacut=%str(19DEC2024);
%put datacut=&datacut.;
