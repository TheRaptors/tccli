FROM centos:7

# 设置编码，无此配置则不支持中文
ENV LANG en_US.UTF-8

RUN rm -rf /etc/yum.repos.d/*

# 添加腾讯软件源
ADD http://mirrors.cloud.tencent.com/repo/centos7_base.repo /etc/yum.repos.d/CentOS-Base.repo
ADD http://mirrors.cloud.tencent.com/repo/epel-7.repo /etc/yum.repos.d/epel.repo

# 添加 jq，以 json 的格式输出
RUN yum clean all && yum makecache && yum -y install jq python python-devel python-pip

# 安装腾讯云命令行工具
RUN pip install tccli -i https://mirrors.cloud.tencent.com/pypi/simple

# 命令补全
RUN echo "complete -C 'tccli_completer' tccli" >> ~/.bashrc && source ~/.bashrc

# 配置 API 密钥(https://console.cloud.tencent.com/cam/capi)
RUN tccli configure set secretId xxxx
RUN tccli configure set secretKey xxxx

# # 以下两项配置为默认配置，可跳过
# RUN tccli configure set region ap-guangzhou
# RUN tccli configure set output json

CMD ["tccli", "--version"]
