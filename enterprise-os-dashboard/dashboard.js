/* Copyright (c) 2025 Devin B. Royal. All Rights Reserved. */
document.addEventListener("DOMContentLoaded", () => {
    const projectData = {
        "chimera": {
            title: "CHIMERA™",
            subtitle: "GCP / K8s / Governance",
            purpose: "Internal Developer Platform (IDP) for GCP & Kubernetes. Manages governance, SBOM, and policy-as-code.",
            tags: ["GCP", "Kubernetes", "SPDX", "SBOM", "Policy-as-Code", "Go", "Python"],
            make: "build test scan package",
            metrics: { latency: "120ms", errorRate: "0.05%", builds: 42 },
            color: "gcp",
            build: { status: "Build #2049: SUCCESS", commit: "a4fde01" },
            scan: { critical: 0, high: 2, medium: 5 },
            runtime: { targets: "chimera-dev, chimera-prod", deploy: "15m ago" },
            health: { api: "healthy", workers: "healthy" }
        },
        "aegis": {
            title: "AEGIS™",
            subtitle: "AWS / Security Pipelines",
            purpose: "Security & Guardrails for AWS. Manages CI/CD security, IAM policies, and real-time threat detection.",
            tags: ["AWS", "Security", "IAM", "CI/CD", "Java", "Rust"],
            make: "build test scan package-lambda",
            metrics: { latency: "40ms", errorRate: "0.01%", builds: 78 },
            color: "aws",
            build: { status: "Build #1102: SUCCESS", commit: "b9c011a" },
            scan: { critical: 0, high: 0, medium: 1 },
            runtime: { targets: "aegis-scanner, aegis-remediator", deploy: "4h ago" },
            health: { scanner: "healthy", remediator: "healthy" }
        },
        "sentry": {
            title: "SENTRY™",
            subtitle: "Azure / Telemetry & Guardrails",
            purpose: "Telemetry and Guardrails for Azure. Monitors compliance, logs, and metrics against security baselines.",
            tags: ["Azure", "Telemetry", "Compliance", "C#", ".NET"],
            make: "build test scan package-func",
            metrics: { latency: "80ms", errorRate: "0.02%", builds: 31 },
            color: "azure",
            build: { status: "Build #904: FAILED", commit: "c03f8a2" },
            scan: { critical: 1, high: 4, medium: 10 },
            runtime: { targets: "sentry-collector (prod)", deploy: "2d ago" },
            health: { collector: "degraded", api: "healthy" }
        },
        "veritas": {
            title: "VERITAS™",
            subtitle: "Oracle / Data & Audit",
            purpose: "Data integrity and audit platform for Oracle DB. Ensures data compliance and manages audit trails.",
            tags: ["Oracle", "Database", "Audit", "PL/SQL", "Java"],
            make: "build test-db scan-sql",
            metrics: { latency: "300ms", errorRate: "0.00%", builds: 10 },
            color: "oracle",
            build: { status: "Build #109: SUCCESS", commit: "f1a9e20" },
            scan: { critical: 0, high: 1, medium: 1 },
            runtime: { targets: "veritas-db-prod, veritas-api", deploy: "1h ago" },
            health: { api: "healthy", db-conn: "healthy" }
        },
        "synergy": {
            title: "SYNERGY™",
            subtitle: "Apple / Edge & Client",
            purpose: "Edge computing and client-side logic for Apple devices. Manages secure enclave and on-device processing.",
            tags: ["Apple", "Edge", "Swift", "C++", "Security"],
            make: "build test scan package-framework",
            metrics: { latency: "N/A", errorRate: "N/A", builds: 25 },
            color: "apple",
            build: { status: "Build #304: SUCCESS", commit: "e5f0a1b" },
            scan: { critical: 0, high: 0, medium: 3 },
            runtime: { targets: "iOS 17.x, macOS 14.x", deploy: "N/A" },
            health: { core: "healthy", enclave: "healthy" }
        },
        "clarity": {
            title: "CLARITY™",
            subtitle: "Meta / Analytics & Signals",
            purpose: "Real-time analytics and signal processing from Meta platforms. Ingests and analyzes user interaction data.",
            tags: ["Meta", "Analytics", "Signals", "Hack", "Python"],
            make: "build test scan",
            metrics: { latency: "10ms", errorRate: "0.50%", builds: 102 },
            color: "meta",
            build: { status: "Build #4091: SUCCESS", commit: "d8c3b01" },
            scan: { critical: 0, high: 3, medium: 3 },
            runtime: { targets: "clarity-ingestor, clarity-api", deploy: "5m ago" },
            health: { ingestor: "healthy", api: "healthy" }
        },
        "orchard": {
            title: "ORCHARD™",
            subtitle: "IBM / Legacy & Mainframe",
            purpose: "Modernization layer for IBM Mainframes. Provides REST/MQ gateways to legacy COBOL applications.",
            tags: ["IBM", "Mainframe", "MQ", "Java", "COBOL"],
        
    make: "build test scan-cobol package-ear",
            metrics: { latency: "800ms", errorRate: "0.10%", builds: 5 },
            color: "ibm",
            build: { status: "Build #55: SUCCESS", commit: "a99b0c2" },
            scan: { critical: 0, high: 1, medium: 8 },
            runtime: { targets: "zOS-CICS, mq-gateway", deploy: "8h ago" },
            health: { cics: "healthy", mq: "healthy" }
        },
        "connect": {
            title: "CONNECT™",
            subtitle: "OpenAI / AI & LLM Control Plane",
            purpose: "Control plane for managing OpenAI models. Handles prompt engineering, security, and cost control.",
            tags: ["OpenAI", "LLM", "AI", "Python", "API"],
            make: "build test scan package-wheel",
            metrics: { latency: "500ms", errorRate: "0.20%", builds: 50 },
            color: "openai",
            build: { status: "Build #450: BUILDING", commit: "e11a0c3" },
            scan: { critical: 0, high: 0, medium: 0 },
            runtime: { targets: "connect-api-prod", deploy: "20m ago" },
            health: { api: "healthy", gpt4-link: "healthy" }
        }
    };

    const DOM = {
        body: document.body,
        modeToggles: document.querySelectorAll(".mode-toggle"),
        status: {
            cicd: document.querySelector("#status-cicd .value"),
            security: document.querySelector("#status-security .value"),
            infra: document.querySelector("#status-infra .value")
        },
        clock: {
            utc: document.getElementById("time-utc"),
            local: document.getElementById("time-local")
        },
        eventStream: document.getElementById("event-stream"),
        consoleInput: document.getElementById("console-input-field"),
        consoleOutput: document.getElementById("console-output"),
        coreNodes: document.querySelectorAll(".core-node"),
        tooltip: document.getElementById("tooltip"),
        rightPanel: document.getElementById("right-panel"),
        detail: {
            header: document.getElementById("detail-header"),
            content: document.getElementById("detail-content"),
            placeholder: document.getElementById("detail-placeholder"),
            template: document.getElementById("detail-template")
        },
        ciList: document.getElementById("ci-pipeline-list"),
        chimeraBanners: document.getElementById("chimera-banners")
    };

    let currentMode = "safe";
    let selectedNode = null;

    /* --- Event Log --- */
    function logEvent(message, level = "info") {
        const line = document.createElement("div");
        line.className = `log-line log-`;
        line.textContent = `[] `;
        DOM.eventStream.appendChild(line);
        DOM.eventStream.scrollTop = DOM.eventStream.scrollHeight;
    }

    /* --- Mode Switching --- */
    function setMode(mode) {
        currentMode = mode;
        DOM.body.className = `-mode`;
        DOM.modeToggles.forEach(btn => {
            btn.classList.toggle("active", btn.dataset.mode === mode);
        });
        logEvent(`System mode changed to `, mode === "god" ? "god" : "info");
        if (mode === "god") {
            logEvent("WARNING: GOD MODE ACTIVE. Safety interlocks disabled.", "god");
        }
    }

    /* --- Clock --- */
    function updateClock() {
        const now = new Date();
        DOM.clock.utc.textContent = now.toLocaleTimeString("en-US", { timeZone: "UTC", hour12: false });
        DOM.clock.local.textContent = now.toLocaleTimeString("en-US", { hour12: false });
    }

    /* --- Project Detail Panel --- */
    function showProjectDetails(id) {
        const data = projectData[id];
        if (!data) return;

        if (selectedNode) selectedNode.classList.remove("selected");
        selectedNode = document.getElementById(`node-`);
        if (selectedNode) selectedNode.classList.add("selected");

        DOM.detail.placeholder.style.display = "none";
        const content = DOM.detail.template.content.cloneNode(true);

        DOM.detail.header.textContent = ` • `;
        content.getElementById("detail-tags").innerHTML = data.tags.map(tag => `<span></span>`).join("");
        content.getElementById("detail-build-status").textContent = ` (commit )`;
        content.getElementById("detail-make-targets").innerHTML = data.make.split(" ").map(t => `<span></span>`).join("");
        content.getElementById("detail-last-scan").textContent = `Last Scan:  Crit •  High •  Med`;
        content.getElementById("detail-runtime-targets").textContent = `Targets: `;
        content.getElementById("detail-last-deploy").textContent = `Last Deploy: `;

        const health = content.getElementById("detail-health");
        health.innerHTML = Object.entries(data.health).map(([key, val]) => {
            const statusClass = val === "healthy" ? "green" : "red";
            return `<span>: <span class=""></span></span>`;
        }).join("");

        DOM.detail.content.innerHTML = "";
        DOM.detail.content.appendChild(content);
        logEvent(`Selected project: `);

        DOM.chimeraBanners.style.opacity = (id === "chimera") ? "1" : "0";
    }

    /* --- Node Tooltips --- */
    function showTooltip(e, id) {
        const data = projectData[id];
        if (!data) return;
        DOM.tooltip.style.opacity = "1";
        DOM.tooltip.innerHTML = `\
            <div class="tooltip-title"></div>\
            <div class="tooltip-lang"></div>\
            <div></div>\
            <div class="tooltip-metrics">\
                <div>Metrics:  /  /  builds</div>\
                <div class="tooltip-make">make </div>\
            </div>\
        `;
        DOM.tooltip.style.left = `px`;
        DOM.tooltip.style.top = `px`;
    }
    function hideTooltip() {
        DOM.tooltip.style.opacity = "0";
    }

    /* --- Console --- */
    function handleConsoleInput(e) {
        if (e.key === "Enter") {
            const command = e.target.value;
            const outputLine = document.createElement("div");
            outputLine.innerHTML = `<span class="console-prompt">duke></span> `;
            DOM.consoleOutput.appendChild(outputLine);

            logEvent(`Command executed: `, "info");
            processCommand(command);
            e.target.value = "";
            DOM.consoleOutput.scrollTop = DOM.consoleOutput.scrollHeight;
        }
    }
    function processCommand(command) {
        const args = command.split(" ");
        const cmd = args[0];
        const response = document.createElement("div");
        let responseText = ``;

        if (currentMode !== "god" && (cmd.includes("prod") || cmd.includes("deploy") || cmd.includes("god"))) {
            responseText = `ERROR: Permission denied. Switch to GOD MODE for production access.`;
            response.style.color = "var(--color-status-red)";
        } else if (command.startsWith("make")) {
            responseText = `Executing \`\`... Task queued.`;
        } else if (command.startsWith("show status")) {
            const proj = args[2];
            if (projectData[proj]) {
                responseText = `Status for : , Health: `;
            } else {
                responseText = `Unknown project: `;
            }
        } else if (command === "clear") {
            DOM.consoleOutput.innerHTML = "";
        } else {
            responseText = `Unknown command: `;
        }

        if (responseText) {
            response.textContent = responseText;
            DOM.consoleOutput.appendChild(response);
        }
    }

    /* --- Simulation & Initialization --- */
    function initDashboard() {
        setMode(currentMode);
        updateClock();
        setInterval(updateClock, 1000);

        logEvent("Enterprise-OS v3.0 initializing...");
        logEvent("DUKEªٱ QAOS CORE: ONLINE.");
        logEvent("Connecting to all project nodes...");

        // Init Mode Toggles
        DOM.modeToggles.forEach(btn => {
            btn.addEventListener("click", () => setMode(btn.dataset.mode));
        });

        // Init Core Nodes
        DOM.coreNodes.forEach(node => {
            const id = node.dataset.id;
            const data = projectData[id];
            if(data) {
                node.dataset.color = data.color;
            }
            node.addEventListener("click", () => showProjectDetails(id));
            node.addEventListener("mouseover", (e) => showTooltip(e, id));
            node.addEventListener("mouseout", hideTooltip);
        });

        // Init Console
        DOM.consoleInput.addEventListener("keydown", handleConsoleInput);

        // Start simulation
        simulateGlobalStatus();
        initPipelines();
        showProjectDetails("chimera"); // Start focused on Chimera
        logEvent("Dashboard ready. SAFE MODE active.", "info");
    }

    function initPipelines() {
        DOM.ciList.innerHTML = "";
        Object.keys(projectData).forEach(id => {
            const data = projectData[id];
            const status = data.build.status.toLowerCase();
            let state = "success";
            if (status.includes("failed")) state = "failed";
            if (status.includes("building")) state = "running";

            const pipelineEl = document.createElement("div");
            pipelineEl.className = "ci-pipeline";
            pipelineEl.innerHTML = `\
                <span class="pipeline-name"></span>\
                <span class="pipeline-status "></span>\
                <div class="pipeline-stages">\
                    <span class="stage ">B</span>\
                    <span class="stage ">T</span>\
                    <span class="stage ">S</span>\
                    <span class="stage ">P</span>\
                </div>\
            `;
            DOM.ciList.appendChild(pipelineEl);
        });
        // Add CSS for pipelines
        const style = document.createElement("style");
        style.innerHTML = `\
            .ci-pipeline { display: grid; grid-template-columns: 1fr 60px auto; align-items: center; font-size: 0.8rem; margin-bottom: 5px; }
            .pipeline-name { font-weight: 500; }
            .pipeline-status { font-size: 0.7rem; font-weight: 700; }
            .pipeline-status.success { color: var(--color-status-green); }
            .pipeline-status.failed { color: var(--color-status-red); }
            .pipeline-status.running { color: var(--color-status-amber); }
            .pipeline-stages { display: flex; gap: 3px; }
            .pipeline-stages .stage { width: 18px; height: 18px; font-size: 0.7rem; font-weight: 700; display: flex; align-items: center; justify-content: center; border-radius: 3px; background: var(--color-border); color: var(--color-text-secondary); }
            .pipeline-stages .stage.success { background: var(--color-status-green); color: var(--color-dark-bg); }
            .pipeline-stages .stage.failed { background: var(--color-status-red); color: #fff; }
            .pipeline-stages .stage.running { background: var(--color-status-amber); color: var(--color-dark-bg); }
        `;
        document.head.appendChild(style);
    }

    function simulateGlobalStatus() {
        // Simulate Node Status
        DOM.coreNodes.forEach(node => {
            const id = node.dataset.id;
            const status = projectData[id].build.status.toLowerCase();
            if (status.includes("failed")) node.dataset.status = "failed";
            else if (status.includes("building")) node.dataset.status = "building";
            else node.dataset.status = "healthy";
        });

        // Simulate Top Bar
        DOM.status.cicd.textContent = "ALL PIPELINES STABLE";
        DOM.status.cicd.className = "value green";
        if (projectData.sentry.build.status.includes("FAILED")) {
            DOM.status.cicd.textContent = "1 FAILED";
            DOM.status.cicd.className = "value red";
        }

        const totalVulns = Object.values(projectData).reduce((sum, p) => sum + p.scan.critical, 0);
        DOM.status.security.textContent = ` CRITICAL VULNS`;
        if (totalVulns > 0) DOM.status.security.style.color = "var(--color-status-red)";

        DOM.status.infra.textContent = "DRIFT DETECTED";
        DOM.status.infra.style.color = "var(--color-status-red)";
    }

    initDashboard();
});
