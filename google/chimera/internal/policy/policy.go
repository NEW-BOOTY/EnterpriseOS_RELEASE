package policy

import (
	"os"
	"gopkg.in/yaml.v3"
)

type Rule struct {
	SPDX     string   `yaml:"spdx"`
	Action   string   `yaml:"action"` // allow, deny
	Reason   string   `yaml:"reason"`
}

var Rules []Rule

func LoadRules(path string) error {
	data, err := os.ReadFile(path)
	if err != nil { return err }
	return yaml.Unmarshal(data, &Rules)
}

func IsAllowed(spdx string) (bool, string) {
	for _, r := range Rules {
		if r.SPDX == spdx {
			if r.Action == "deny" {
				return false, r.Reason
			}
		}
	}
	return true, ""
}
