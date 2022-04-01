package main

import (
	"context"
	"flag"
	"os"
	"strings"

	"github.com/gen2brain/dlgs"
	"tailscale.com/client/tailscale"
	"tailscale.com/tailcfg"
)

var filename = flag.String("filename", "", "File to push via Taildrop")

func getTargets(ctx context.Context) (map[string]*tailcfg.Node, error) {
	targets := make(map[string]*tailcfg.Node)
	ts, err := tailscale.FileTargets(ctx)
	if err != nil {
		return nil, err
	}
	for _, t := range ts {
		targets[t.Node.ComputedName] = t.Node
	}
	return targets, nil
}

func pushFile(ctx context.Context, node *tailcfg.Node, filename string) error {
	f, err := os.Open(filename)
	if err != nil {
		return err
	}
	stat, err := os.Stat(filename)
	if err != nil {
		return err
	}
	return tailscale.PushFile(ctx, node.StableID, stat.Size(), stat.Name(), f)
}

func main() {
	flag.Parse()

	ctx := context.Background()
	targets, err := getTargets(ctx)
	if err != nil {
		dlgs.Error("Failed to Taildrop file", err.Error())
		panic(err)
	}

	var targetNames []string
	for name, _ := range targets {
		targetNames = append(targetNames, name)
	}

	selection, success, err := dlgs.List("List", "Select item from list:", targetNames)
	if err != nil {
		dlgs.Error("Failed to Taildrop file", err.Error())
		panic(err)
	}
	if !success {
		panic("Didn't succeed")
	}

	selectedNode := targets[selection]
	err = pushFile(ctx, selectedNode, strings.TrimSpace(*filename))
	if err != nil {
		dlgs.Error("Failed to Taildrop file", err.Error())
		panic(err)
	}
}
