# 🗄️ VideoCore DB

<div align="center">

Provisionamento e gerenciamento de banco de dados Azure Cosmos DB para o ecossistema VideoCore. Desenvolvido como parte do curso de Arquitetura de Software da FIAP (Tech Challenge).

</div>

<div align="center">
  <a href="#visao-geral">Visão Geral</a> •
  <a href="#arquitetura">Arquitetura</a> •
  <a href="#repositorios">Repositórios</a> •
  <a href="#tecnologias">Tecnologias</a> •
  <a href="#instalacao">Instalação</a> •
  <a href="#deploy">Fluxo de Deploy</a> •
  <a href="#contribuicao">Contribuição</a>
</div><br>

> 📽️ Vídeo de demonstração da arquitetura: [https://youtu.be/k3XbPRxmjCw](https://youtu.be/k3XbPRxmjCw)<br>

---

<h2 id="visao-geral">📋 Visão Geral</h2>

O **VideoCore DB** é o repositório responsável por provisionar a infraestrutura de banco de dados do sistema VideoCore, utilizando **Azure Cosmos DB (NoSQL)** como engine principal para persistência de relatórios de processamento de vídeo.

### Principais Responsabilidades

- **Provisionamento**: Criação e configuração do Azure Cosmos DB via Terraform
- **Rede**: Configuração de VNet e subnet dedicada para o banco de dados
- **Alta Disponibilidade**: Failover automático para região secundária
- **Desenvolvimento Local**: Emulador do Cosmos DB via Docker

### Configurações do Cosmos DB

| Parâmetro | Valor |
|-----------|-------|
| **Tipo** | GlobalDocumentDB (NoSQL) |
| **Consistência** | Session |
| **Oferta** | Standard |
| **Failover Automático** | Habilitado |
| **Região Secundária** | West US 3 (padrão) |
| **Subnet** | 10.0.7.0/24 |

---

<h2 id="arquitetura">🧱 Arquitetura</h2>

<details>
<summary>Expandir para mais detalhes</summary>

### 🎯 Módulos Terraform

O projeto utiliza uma arquitetura modular com os seguintes módulos:

| Módulo | Descrição |
|--------|-----------|
| **vnet** | Configuração de Virtual Network e subnets |
| **azure_cosmos_db_reports** | Provisionamento do Cosmos DB para relatórios |

### 🔒 Segurança de Rede

- **Private Endpoint**: Comunicação segura via endpoint privado
- **Private DNS Zone**: Resolução DNS interna para o Cosmos DB
- **Subnet dedicada**: Isolamento de rede para o banco de dados

### 📊 Modelo de Dados

O Cosmos DB armazena relatórios de processamento de vídeo, incluindo:
- Status do processamento (STARTED, PROCESSING, COMPLETED, FAILED)
- Metadados do vídeo processado
- Referências para screenshots gerados
- Timestamps de criação e atualização

### 📦 Estrutura do Projeto

```
videocore-db/
├── terraform/
│   ├── main.tf              # Orquestração dos módulos
│   ├── variables.tf          # Variáveis de configuração
│   ├── datasources.tf        # Data sources remotos
│   ├── backend.tf            # Estado remoto (Azure Storage)
│   └── modules/
│       ├── vnet/             # Rede virtual
│       └── azure_cosmos_db_reports/  # Cosmos DB
├── docker/
│   ├── docker-compose.yml    # Emulador Cosmos DB
│   └── env-example           # Variáveis de ambiente
├── docs/
│   └── mermaid-code/
│       └── DER.mmd           # Diagrama ER
└── scripts/
    ├── infra-up.sh           # Subir ambiente local
    ├── infra-down.sh         # Derrubar ambiente
    └── infra-restart.sh      # Reiniciar ambiente
```

</details>

---

<h2 id="repositorios">📁 Repositórios do Ecossistema</h2>

| Repositório | Responsabilidade | Tecnologias |
|-------------|------------------|-------------|
| **videocore-infra** | Infraestrutura base (AKS, VNET, APIM, Key Vault) | Terraform, Azure, AWS |
| **videocore-db** | Banco de dados (este repositório) | Terraform, Azure Cosmos DB |
| **videocore-frontend** | Interface web do usuário | Next.js 16, React 19, TypeScript |
| **videocore-reports** | Microsserviço de relatórios | Java 25, Spring Boot 4, Cosmos DB |
| **videocore-worker** | Microsserviço de processamento de vídeo | Java 25, Spring Boot 4, FFmpeg |
| **videocore-observability** | Stack de observabilidade | OpenTelemetry, Jaeger, Prometheus, Grafana |

---

<h2 id="tecnologias">🔧 Tecnologias</h2>

| Categoria | Tecnologia |
|-----------|------------|
| **IaC** | Terraform |
| **Banco de Dados** | Azure Cosmos DB (NoSQL) |
| **Rede** | Azure VNet, Private Endpoint, Private DNS |
| **Emulação** | Azure Cosmos DB Linux Emulator (Docker) |
| **CI/CD** | GitHub Actions |
| **Cloud** | Microsoft Azure |

---

<h2 id="instalacao">🚀 Instalação e Uso</h2>

### Desenvolvimento Local

```bash
# Clonar repositório
git clone https://github.com/FIAP-SOAT-TECH-TEAM/videocore-db.git
cd videocore-db

# Configurar variáveis de ambiente
cp docker/env-example docker/.env

# Subir emulador do Cosmos DB
./video start:infra
```

> ⚠️ O emulador requer no mínimo **3 GB de RAM** e **2 CPUs** disponíveis.

---

<h2 id="deploy">⚙️ Fluxo de Deploy</h2>

<details>
<summary>Expandir para mais detalhes</summary>

### Pipeline

1. **Pull Request** → CI: Terraform Format, Validate e Plan
2. **Revisão e Aprovação** → Mínimo 1 aprovação de CODEOWNER
3. **Merge para Main** → CD: Terraform Apply

### Autenticação

- **OIDC**: Token emitido pelo GitHub
- **Azure AD Federation**: Confia no emissor GitHub
- **Service Principal**: Autentica sem secret

### Ordem de Provisionamento

```
1. videocore-infra          (AKS, VNET, APIM)
2. videocore-db             (Cosmos DB - este repositório)
3. videocore-auth           (Azure Function Authorizer)
4. videocore-reports        (Microsserviço de relatórios)
5. videocore-worker         (Microsserviço de processamento)
6. videocore-notification   (Microsserviço de notificações)
7. videocore-frontend       (Interface web)
```

### Proteções

- Branch `main` protegida
- Nenhum push direto permitido
- Todos os checks devem passar

</details>

---

<h2 id="contribuicao">🤝 Contribuição</h2>

### Fluxo de Contribuição

1. Crie uma branch a partir de `main`
2. Implemente suas alterações
3. Abra um Pull Request
4. Aguarde aprovação de um CODEOWNER

<h2 id="deploy">⚙️ Fluxo de Deploy</h2>

<details>
<summary>Expandir para mais detalhes</summary>

### Pipeline

1. **Pull Request** → CI: Terraform Init / Plan
2. **Revisão e Aprovação** → Mínimo 1 aprovação de CODEOWNER
3. **Merge para Main** → CD: Terraform Apply

### Autenticação

- **OIDC**: Token emitido pelo GitHub
- **Azure AD Federation**: Confia no emissor GitHub
- **Service Principal**: Autentica sem secret

### Ordem de Provisionamento

```
1. videocore-infra          (AKS, VNET, APIM, Key Vault)
2. videocore-db             (Cosmos DB - este repositório)
3. videocore-observability  (Jaeger, Prometheus, Grafana)
4. videocore-reports        (Microsserviço de relatórios)
5. videocore-worker         (Microsserviço de processamento)
6. videocore-frontend       (Interface web)
```

### Proteções

- Branch `main` protegida
- Nenhum push direto permitido
- Todos os checks devem passar

</details>

---

<h2 id="contribuicao">🤝 Contribuição</h2>

### Fluxo de Contribuição

1. Crie uma branch a partir de `main`
2. Implemente suas alterações
3. Abra um Pull Request
4. Aguarde aprovação de um CODEOWNER

### Licença

Este projeto está licenciado sob a [MIT License](LICENSE).

---

<div align="center">
  <strong>FIAP - Pós-graduação em Arquitetura de Software</strong><br>
  Tech Challenge
</div>