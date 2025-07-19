# Investment Pool Platform

A decentralized investment fund management platform on Stacks blockchain. Fund managers create investment pools, investors contribute capital, and regulators ensure compliance.

## Features

- **Fund Creation**: Managers establish investment funds with strategies
- **Capital Investment**: Investors contribute to regulated funds
- **Regulatory Compliance**: Chief regulator approves fund operations
- **Transparent Tracking**: Complete investment and approval history

## Smart Contract Functions

### Public Functions
- `create-fund`: Establish a new investment fund
- `invest-in-fund`: Contribute capital to approved funds
- `approve-fund`: Regulatory approval process (regulator only)

### Read-Only Functions
- `get-fund`: Retrieve fund information
- `get-investment-ledger`: View investment history
- `get-investment-count`: Get total fund investments

## Getting Started

1. Deploy contract with regulatory oversight
2. Fund managers create investment strategies
3. Investors contribute to approved funds
4. Regulator ensures compliance and approves funds

## Error Codes

- `u1`: Invalid minimum investment
- `u2`: Fund not found
- `u3`: Manager cannot invest in own fund
- `u4`: Unauthorized regulator access
- `u5`: Invalid fund name
- `u6`: Invalid investment strategy
- `u7`: Invalid fund term
- `u8`: Invalid fund ID
```

**PR Title**: feat: launch investment pool platform with regulatory compliance

**PR Description**: 
Implements a sophisticated investment fund management system with manager fund creation, investor capital contribution, and regulatory approval workflows. Features transparent investment tracking and compliance mechanisms.

**README Commit**: docs: establish investment platform documentation with compliance guide

**Code Commit**: feat: develop fund management and investment system with regulatory controls

**Branch Name**: feature/investment-pool-platform

---

