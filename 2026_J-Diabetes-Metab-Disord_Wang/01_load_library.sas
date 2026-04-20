/*create a library*/
libname AD '/users/55548/c-ywang911-55548/AD/'; run;

/*beneficiaries summary, including demographic information and insurance enrollment*/
libname mbsf16 '/cms01/data/dua/55548/mbsf/2016/SAS/'; run;
libname mbsf17 '/cms01/data/dua/55548/mbsf/2017/SAS/'; run;
libname mbsf18 '/cms01/data/dua/55548/mbsf/2018/SAS/'; run;
libname mbsf19 '/cms01/data/dua/55548/mbsf/2019/SAS/'; run;
libname mbsf20 '/cms01/data/dua/55548/mbsf/2020/SAS/'; run;

/*Part D drug claims*/
libname partd16 ‘/cms01/data/dua/55548/part_d_pde/2016/SAS/’; run;
libname partd17 ‘/cms01/data/dua/55548/part_d_pde/2017/SAS/’; run;
libname partd18 ‘/cms01/data/dua/55548/part_d_pde/2018/SAS/’; run;
libname partd19 ‘/cms01/data/dua/55548/part_d_pde/2019/SAS/’; run;
libname partd20 '/cms01/data/dua/55548/part_d_pde/2020/SAS/'; run;

/*inpatient files*/
libname ip16 '/cms01/data/dua/55548/tm_ip/2016/SAS/'; run;
libname ip17 '/cms01/data/dua/55548/tm_ip/2017/SAS/'; run;
libname ip18 '/cms01/data/dua/55548/tm_ip/2018/SAS/'; run;
libname ip19 '/cms01/data/dua/55548/tm_ip/2019/SAS/'; run;
libname ip20 '/cms01/data/dua/55548/tm_ip/2020/SAS/'; run;

/*outpatient files*/
libname op16‘/cms01/data/dua/55548/tm_op/2016/SAS/’; run;
libname op17 ‘/cms01/data/dua/55548/tm_op/2017/SAS/’; run;
libname op18 ‘/cms01/data/dua/55548/tm_op/2018/SAS/’; run;
libname op19 ‘/cms01/data/dua/55548/tm_op/2019/SAS/’; run;
libname op20 ‘/cms01/data/dua/55548/tm_op/2020/SAS/’; run;
