from core.agents.agent_base import CognitiveAgent
from cognitive.neuro_symbolic.engine import NeuroSymbolicReasoner

class EnterpriseOSSDK:
    def __init__(self, api_key: str):
        self.agent = CognitiveAgent("SDK-Agent", "Developer")
        self.reasoner = NeuroSymbolicReasoner()

    def ask(self, question: str):
        return self.reasoner.reason(question)
