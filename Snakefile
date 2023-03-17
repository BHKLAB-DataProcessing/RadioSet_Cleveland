from snakemake.remote.S3 import RemoteProvider as S3RemoteProvider
S3 = S3RemoteProvider(
    access_key_id=config["key"],
    secret_access_key=config["secret"],
    host=config["host"],
    stay_on_remote=False
)

prefix = config["prefix"]
filename = config["filename"]

rule get_radioset:
    input:
        S3.remote(prefix + "download/CCLE.rds"),
        S3.remote(prefix + "download/cell_annotation_all.csv"),
        S3.remote(prefix + "download/XRT_CTD2_Dose_Response.xlsx")
    output:
        S3.remote(prefix + filename)
    shell:
        """
        Rscript scripts/get_Cleveland.R {prefix}       
        """

rule download_data:
    output:
        S3.remote(prefix + "download/CCLE.rds"),
        S3.remote(prefix + "download/cell_annotation_all.csv"),
        S3.remote(prefix + "download/XRT_CTD2_Dose_Response.xlsx")
    shell:
        """
        wget 'https://zenodo.org/record/3905462/files/CCLE.rds?download=1' -O {prefix}download/CCLE.rds
        wget 'https://github.com/BHKLAB-DataProcessing/Annotations/raw/master/cell_annotation_all.csv' \
            -O {prefix}download/cell_annotation_all.csv
        wget 'https://github.com/BHKLAB-DataProcessing/RadioSet_Cleveland-snakemake/raw/main/data/XRT_CTD2_Dose_Response.xlsx' \
            -O {prefix}download/XRT_CTD2_Dose_Response.xlsx
        """
