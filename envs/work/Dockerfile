FROM condaforge/miniforge3:latest

RUN apt-get update
RUN apt-get install -y file 

# Step 2: Generate conda environments

RUN <<EOR
    conda config --add channels nodefaults
    conda config --add channels bioconda
    conda config --add channels conda-forge
    conda config --set channel_priority strict
EOR


# Create a new environment named 'work' and install packages
RUN conda create --no-default-packages -n work htslib -y && conda clean --all -y

# bedtools samtools
RUN conda install -n work bedtools samtools -y && conda clean --all -y

# python base
RUN conda install -n work python pandas click numpy tqdm pysam pyfaidx -y && conda clean --all -y

RUN conda install -n work fasta-splitter -y && conda clean --all -y

RUN echo "source activate work" > ~/.bashrc
ENV PATH=/opt/conda/envs/work/bin:$PATH
# Make RUN commands use the new environment
SHELL ["conda", "run", "--no-capture-output", "-n", "work", "/bin/bash", "-c"]


# Copy concat_files.sh script to /opt/conda/envs/work/bin directory
COPY scripts/concat_files.sh /opt/conda/envs/work/bin/concat_files.sh

# Make the script executable
RUN chmod +x /opt/conda/envs/work/bin/concat_files.sh

EXPOSE 5003
# Ensure the environment is activated on start
ENTRYPOINT ["conda", "run", "--no-capture-output", "-n", "work", "bash", "-c"]
CMD ["echo", "Environment work is activated!"]
