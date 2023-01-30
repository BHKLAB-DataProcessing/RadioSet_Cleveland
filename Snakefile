from snakemake.remote.S3 import RemoteProvider as S3RemoteProvider
# S3 = S3RemoteProvider(
#     access_key_id=config["key"],
#     secret_access_key=config["secret"],
#     host=config["host"],
#     stay_on_remote=False
# )

prefix = config["prefix"]

rule get_exp_se:
    input:
        prefix + "download/CCLE.rds",
        prefix + "download/cell_annotation_all.csv",
        prefix + "data/XRT_CTD2_Dose_Response.xlsx"
    output:
        prefix + "Cleveland.rds"
    shell:
        """
        Rscript {prefix}scripts/get_Cleveland.R {prefix}       
        """

rule download_data:
    output:
        prefix + "download/CCLE.rds",
        prefix + "download/cell_annotation_all.csv"
    shell:
        """
        wget 'https://zenodo.org/record/3905462/files/CCLE.rds?download=1' -O {prefix}download/CCLE.rds
        wget 'https://github.com/BHKLAB-DataProcessing/Annotations/raw/master/cell_annotation_all.csv' \
            -O {prefix}download/cell_annotation_all.csv
        """
