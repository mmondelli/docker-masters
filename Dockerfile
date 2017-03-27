FROM ubuntu:16.04

MAINTAINER Maria Luiza Mondelli <malumondelli@gmail.com>
EXPOSE 3838

RUN apt-get update

RUN apt-get install -y \
	sqlite3 \
	git \
	wget \
	mafft \
	raxml \
	software-properties-common \
	gdebi-core \
	time \
	libssl1.0.0 \
	vim \
	python-pip
	

# ==================
# JAVA =============
# ==================

ENV JAVA_VERSION 8u91
ENV JAVA_HOME /usr/lib/jvm/jdk1.8.0_111/
COPY jdk-8u111-linux-x64.tar.gz /usr/lib/jvm/
WORKDIR /usr/lib/jvm
RUN tar -zxvf jdk-8u111-linux-x64.tar.gz && \
    rm jdk-8u111-linux-x64.tar.gz
ENV PATH "$PATH":/${JAVA_HOME}/bin:.:

# ==================
# R PACKAGES =======
# ==================

RUN sh -c 'echo "deb http://cran.rstudio.com/bin/linux/ubuntu trusty/" >> /etc/apt/sources.list'
RUN gpg --keyserver keyserver.ubuntu.com --recv-key E084DAB9
RUN gpg -a --export E084DAB9 | apt-key add -

RUN apt-get update

RUN apt-get install -y r-base

RUN R -e "install.packages(c('shiny', 'rmarkdown', 'ggplot2', 'sqldf', 'plyr', 'formattable', 'RColorBrewer', 'shinydashboard', 'DT', 'plyr', 'dplyr', 'reshape', 'lubridate', 'scales', 'anytime', 'shinyjs'), repos='https://cloud.r-project.org/')"


# ==================
# SHINY ============
# ==================

RUN wget -O shiny-server.deb http://download3.rstudio.org/ubuntu-12.04/x86_64/shiny-server-1.3.0.403-amd64.deb
#RUN gdebi -n shiny-server.deb

# ==================
# SWIFT-PHYLO ======
# ==================

RUN cd /root; git clone https://github.com/mmondelli/swift-phylo.git
ENV SWIFT_PHYLO /root/swift-phylo
ENV PATH "$PATH":/${SWIFT_PHYLO}/bin:.:

# ==================
# SWIFT-GECKO ======
# ==================

RUN cd /root; git clone https://github.com/mmondelli/swift-gecko.git
ENV SWIFT_GECKO /root/swift-gecko
ENV PATH "$PATH":/${SWIFT_GECKO}/bin:.:

# ==================
# PAGERANK =========
# ==================

RUN cd /root; git clone https://github.com/mmondelli/swift-pagerank.git

# ==================
# RASFLOW ==========
# ==================

RUN cd /root; git clone https://github.com/mmondelli/rasflow.git
ENV RASFLOW /root/rasflow
ENV PATH "$PATH":/${RASFLOW}/bin:.:

# TABIX E BGZIP ====

RUN cd /usr/local; wget https://sourceforge.net/projects/samtools/files/tabix/tabix-0.2.6.tar.bz2 && \
     tar xjvf tabix-0.2.6.tar.bz2; cd tabix-0.2.6; make
ENV PATH "$PATH":/usr/local/tabix-0.2.6:.:

# VCF TOOLS ========

RUN cd /usr/local; wget https://sourceforge.net/projects/vcftools/files/vcftools_0.1.13.tar.gz && \
	tar xvfz vcftools_0.1.13.tar.gz; cd vcftools_0.1.13; make 
ENV PATH "$PATH":/usr/local/vcftools_0.1.13/bin:.:

# BOWTIE 2.1.0 =====

RUN cd /usr/local; wget https://sourceforge.net/projects/bowtie-bio/files/bowtie2/2.1.0/bowtie2-2.1.0-linux-x86_64.zip && \
	unzip bowtie2-2.1.0-linux-x86_64.zip 
ENV PATH "$PATH":/usr/local/bowtie2-2.1.0:.:

# ==================
# SWIFT ============
# ==================

RUN cd /usr/local; wget http://swift-lang.org/packages/swift-0.96.2.tar.gz && \
    tar xvfz /usr/local/swift-0.96.2.tar.gz 
ENV SWIFT /usr/local/swift-0.96.2
ENV PATH "$PATH":/${SWIFT}/bin:.:

# ==================
# HPSW-PROF ========
# ==================

RUN cd /srv/shiny-server; git clone https://github.com/mmondelli/swift-prof.git
#RUN chmod 755 srv

# ==================
# SAMTOOLS =========
# ==================

#RUN cd /usr/local; wget https://sourceforge.net/projects/samtools/files/samtools/0.1.18/samtools-0.1.18.tar.bz2
#ENV SAMTOOLS /usr/local/swift-0.96.2
#ENV PATH "$PATH":/${SAMTOOLS}/bin:.:

# ==================
# PYTHON PACKAGES ==
# ==================

RUN pip install numpy scipy
RUN pip install biopython


