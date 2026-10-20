# Project zooid: Reclaiming Our Digital Communities


Are you tired of big tech companies using the promise of child safety to justify increasingly invasive surveillance? Are you tired of corporations collecting our personal data, feeding it into AI systems, and building a future where our privacy, livelihoods, and sense of purpose are treated as expendable?

## I am. That's why I started Project zooid.

In biology, a zooid (pronounced /ˈzoʊ.ɔɪd/) is an individual, distinct organism that functions as part of a colonial or compound animal.

## A Different Kind of Communication Platform
Project zooid is an ambitious open-source project built around a simple idea: your community should belong to you, not the platform you use to communicate.

Today's online communities depend on centralized platforms like Discord, Slack, and WhatsApp. These services are convenient, but they also place our conversations, communities, and personal data under the control of corporations. We have grown accustomed to trading our privacy for convenience, often without meaningful alternatives.

## I believe in another way.
Project zooid aims to combine peer-to-peer networking, existing email infrastructure, and community management tools to create a decentralized alternative to traditional messaging platforms.

Almost everyone already has an email address. Email may feel outdated compared to instant messaging, DMs, and real-time chat, but its underlying infrastructure is everywhere. Rather than reinventing the wheel or requiring communities to maintain their own servers, Project zooid explores how we can use this existing infrastructure as a transport layer for communication.

The concept is straightforward: communities could operate through email-based message threads enhanced with metadata for channels, chat rooms, and other familiar community features. By combining these building blocks with peer-to-peer networking, the goal is to minimize reliance on centralized infrastructure and give users greater control over their communications.

This approach has trade-offs. Email was never designed to replicate the speed and seamless experience of Discord, and there are real technical challenges to overcome. Project zooid isn't about pretending those limitations don't exist. It's about exploring a different set of priorities: privacy, ownership, accessibility, and extensibility.

## An Open-Source Alternative, Built Together
My vision is for Project zooid to become an extensible foundation that anyone can build upon, adapt, and improve. I want developers and communities to have the freedom to create their own tools and experiences without being locked into a single corporation's ecosystem.

This isn't about replacing one corporate gatekeeper with another. It's about making centralized platforms less necessary in the first place.

I'm concerned about the growing normalization of digital surveillance, the collection of personal data, and the concentration of power in the hands of a few technology companies. Whatever the stated intentions behind new regulations or platform policies, I believe privacy and individual autonomy should remain fundamental principles of the digital world.

Our conversations with family, friends, and communities deserve to be treated as something more than a source of data to monetize.

## Free, Open Source, and Community-Funded
I could approach this project as a conventional startup, build a proprietary platform, and try to turn it into a lucrative business. Instead, I've chosen to make Project zooid open source, free to download, and open to contributions from anyone who shares the vision.

I want this project to be something people can participate in, not just another product they consume.

If you believe in what I'm building, you can help by contributing code, sharing ideas, testing the software, spreading the word, or donating to support its development.

Donations will go toward sustaining the project and the people working to keep it alive, including supporting my family so I can continue dedicating time to its development. My goal is to build something sustainable without sacrificing the principles that inspired it.

## Join the Movement
If you're discovering Project zooid through Reddit, a gaming community, or another corner of the internet, welcome. I'm glad you're here.

I hope this project can become a genuine alternative for people who want to build and maintain online communities without handing ownership of their conversations to a corporation.

This is an ambitious goal, and there is a lot of work ahead. But I believe we can build communication tools that respect the people who use them, rather than treating those people as the product.

Project zooid is about reclaiming ownership of our digital communities, one conversation at a time.

### ⚠️ Email Provider Terms of Service

Using Project zooid over personal email accounts does not violate email provider ToS by itself — JSON, custom headers, MIME attachments, and IMAP/POP3 access are all standard email features.

What **can** run afoul of ToS depends on behavior, not format:

- **Volume/frequency**: High-frequency automated mail from a personal account can look like spam and trigger rate limits or bans.
- **Bulk mailing**: Using personal accounts for listserv-style distribution often violates ToS (use dedicated sending infrastructure at scale).
- **Inbound automation**: Some providers restrict programmatic IMAP access or automated parsing of mail.

Project zooid is designed for small community scale — similar to a newsletter or group email list. If you plan to run large communities, use dedicated email infrastructure rather than personal Gmail/Outlook accounts.

Not legal advice — review your provider's specific ToS before deploying.

## Let's build something better together.

<img width="1536" height="1024" alt="image" src="https://github.com/user-attachments/assets/108f435e-b59b-4882-8e46-fe043d4c235f" />


## Quick Start

### Install Zig 1.17

#### Linux
```bash
# Using curl
curl -fsS https://get.ziglang.org/zig/1.17.0/zig-linux-x86_64-1.17.0.tar.gz -o zig.tar.gz
tar -xzf zig.tar.gz -C /opt/
export PATH=/opt/zig/zig-1.17.0:$PATH
zig version
```

#### macOS
```bash
# Using curl
curl -fsS https://get.ziglang.org/zig/1.17.0/zig-darwin-x86_64-1.17.0.tar.gz -o zig.tar.gz
tar -xzf zig.tar.gz -C /opt/
export PATH=/opt/zig/zig-1.17.0:$PATH
zig version
```

#### Windows
```powershell
# Download and extract Zig 1.17.0
# Add the zig directory to your PATH
zig version
```

### Verify Installation
```bash
zig version
# Should output: 0.17.0
```

### Clean Clone Build Workflow
```bash
# Clone the repository
git clone https://github.com/jameson-m-jolley/project-zooid.git
cd project-zooid

# Build the project
zig build

# Run tests
zig build test
```

### Build & Test Commands
```bash
# Build the library
zig build

# Run tests
zig build test

# Run the TUI
zig build run-tui
```

### Install libzooid as a Dependency

#### As a package dependency (via `build.zig.zon`)
```zig
const zooid = @import("libzooid");
```

#### Using `zig fetch` from GitHub
```bash
zig fetch --save git+https://github.com/jameson-m-jolley/project-zooid.git#<commit-hash>
# Then add to your build.zig:
const zooid = b.dependency("libzooid", .{
    .target = .target,
    .optimize = .optimize,
});
```

### Protocol Documentation
This project defines its message format in [PROTOCOL.md](PROTOCOL.md), which specifies the JSON envelope structure for email-transported messages. Clients should reference this definition when implementing message serialization and deserialization.

## Project Overview

Project zooid aims to reclaim ownership of our digital communities by combining peer-to-peer networking, existing email infrastructure, and community management tools. The goal is to minimize reliance on centralized platforms while giving users greater control over their communications.

### How it works
- Communities operate through email-based message threads
- JSON metadata is embedded alongside human-readable text
- Peer-to-peer networking supplements the email transport
- Communities have full ownership of their conversation data

### Getting Started
See the [Quick Start](#quick-start) section above for installing Zig and building the project.

## License

Copyright (c) 2026 Project zooid. See [LICENSE](LICENSE) for details.