# Stage 1: Builder
FROM ubuntu:22.04 AS builder

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    tar \
    jq \
    sed \
    libc6 \
    && rm -rf /var/lib/apt/lists/*

# Download and extract binary
RUN curl -LOJ https://github.com/crypto-org-chain/chain-main/releases/download/v3.3.9/chain-main_3.3.9_Linux_x86_64.tar.gz \
    && mkdir -p /chain-main_3.3.9_Linux_x86_64 \
    && tar -zxvf chain-main_3.3.9_Linux_x86_64.tar.gz -C /chain-main_3.3.9_Linux_x86_64 \
    && rm chain-main_3.3.9_Linux_x86_64.tar.gz

# Stage 2: Runtime
FROM ubuntu:22.04

# Install runtime dependencies
RUN apt-get update && apt-get install -y \
    libc6 \
    jq \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Create non-root user and directory structure
RUN useradd -m -s /bin/bash cronos && \
    mkdir -p /home/cronos/.chain-maind/config && \
    chown -R cronos:cronos /home/cronos

# Copy binary from builder
COPY --from=builder --chown=cronos:cronos /chain-main_3.3.9_Linux_x86_64/bin/chain-maind /home/cronos/

# Switch to non-root user
USER cronos
WORKDIR /home/cronos

# Verify binary works
RUN ./chain-maind version

# Initialize node
RUN ./chain-maind init "cronos-node" --chain-id crypto-org-chain-mainnet-1 --home /home/cronos/.chain-maind

# Download and verify genesis.json
RUN curl -s https://raw.githubusercontent.com/crypto-org-chain/mainnet/main/crypto-org-chain-mainnet-1/genesis.json > ~/.chain-maind/config/genesis.json \
    && GENESIS_HASH=$(sha256sum ~/.chain-maind/config/genesis.json | awk '{print $1}') \
    && if [ "$GENESIS_HASH" = "d299dcfee6ae29ca280006eaa065799552b88b978e423f9ec3d8ab531873d882" ]; then echo "Genesis OK"; else echo "Genesis MISMATCHED"; exit 1; fi

# Configuration updates
RUN sed -i.bak -E 's#^(minimum-gas-prices[[:space:]]+=[[:space:]]+)""$#\1"0.025basecro"#' ~/.chain-maind/config/app.toml \
    && sed -i.bak -E 's#^(persistent_peers[[:space:]]+=[[:space:]]+).*$#\1"87c3adb7d8f649c51eebe0d3335d8f9e28c362f2@seed-0.cronos-pos:26656,e1d7ff02b78044795371beb1cd5fb803f9389256@seed-1.cronos-pos.org:26656,2c55809558a4e491e9995962e10c026eb9014655@seed-2.cronos-pos.org:26656"#' ~/.chain-maind/config/config.toml \
    && sed -i.bak -E 's#^(seeds[[:space:]]+=[[:space:]]+).*$#\1""#' ~/.chain-maind/config/config.toml

# State sync configuration
RUN LATEST_HEIGHT=$(curl -s https://rpc.mainnet.cronos-pos.org:443/block | jq -r .result.block.header.height) \
    && BLOCK_HEIGHT=$((LATEST_HEIGHT - 1000)) \
    && TRUST_HASH=$(curl -s "https://rpc.mainnet.cronos-pos.org:443/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash) \
    && sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
    s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"https://rpc.mainnet.cronos-pos.org:443,https://rpc.mainnet.cronos-pos.org:443\"| ; \
    s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
    s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"| ; \
    s|^(seeds[[:space:]]+=[[:space:]]+).*$|\1\"\"|" ~/.chain-maind/config/config.toml

ENTRYPOINT ["./chain-maind", "start", "--home", "/home/cronos/.chain-maind"]