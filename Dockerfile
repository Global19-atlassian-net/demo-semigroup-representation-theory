# Dockerfile for binder
FROM registry.gitlab.com/sagemath/sage/sagemath-dev:9.0-py3

RUN sudo apt-get update && sudo apt-get -qy install graphviz build-essential git g++ && sudo apt-get clean
RUN sage -i gap_packages && rm -rf /home/sage/sage/upstream
RUN sudo apt-get update && sudo apt-get -qq install -y curl \
    &&  curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash - \
    && sudo apt-get install -yq nodejs && sudo npm install npm@latest -g
RUN sage -pip install --no-cache-dir --upgrade ipywidgets
RUN sage -pip install --no-cache-dir dot2tex
RUN sage -pip install --no-cache-dir RISE
RUN sage -pip install --no-cache-dir nbdime
#RUN sage -pip install --no-cache-dir cppyy
RUN sage -pip install --no-cache-dir git+https://github.com/nthiery/sage-gap-semantic-interface/
RUN sage -pip install --no-cache-dir git+https://github.com/nthiery/sage-semigroups/
RUN sage -pip install --no-cache-dir git+https://github.com/zerline/francy-widget/
RUN sage -pip install --no-cache-dir git+https://github.com/sagemath/sage-combinat-widgets/@develop
#RUN sage -pip install --no-cache-dir git+https://github.com/sagemath/sage-combinat-widgets/@master
RUN sage -pip install --no-cache-dir git+https://github.com/sagemath/sage-explorer/@develop

# Ensure this COPY goes *after* installation of prerequisites; otherwise the
# build cache will be invalidated any time we change a file in this repository.
COPY --chown=sage:sage . ${HOME}

# The sagemath-dev images start in SAGE_ROOT by default so set the user's pwd
# back to HOME
WORKDIR ${HOME}

# The default entrypoint used in the sagemath-dev images does not instantiate a
# sage shell, so commands like jupyter don't work; this should be fixed.
# upstream to make the sagemath-dev images easier to use with binder
ENTRYPOINT [ "/home/sage/sage/docker/entrypoint.sh" ]
