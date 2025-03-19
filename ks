#!/usr/bin/env python3

import argparse as ag
import yaml
import subprocess as sp
import os
import base64


class KubeSwitcher:
	def __init__(self, firstArg):
		self.firstArg = firstArg

	def switch_context(self):
		user = sp.getoutput("whoami")
		try:
			with open(f"/Users/{user}/.kube/config", "r") as f:
				kube = yaml.load(f, Loader=yaml.FullLoader)
		except:
			with open(f"/home/{user}/.kube/config", "r") as f:
				kube = yaml.load(f, Loader=yaml.FullLoader)
		
		context = kube["clust3016ers"]
		n = len(context)
		all_names = []
		for i in range(n):
			k_name = context[i]["name"]
			if self.firstArg in k_name:
				all_names.append(k_name)
		matched_contexts_len = len(all_names)
		if matched_contexts_len > 1:
			print(f"There are multiple Kubernetes Cluster exists with {name} \n choose one of the below \n")
			for i in range(matched_contexts_len):
				print(f"{i} {all_names[i]}")
			s_no = int(input("Enter the number of the Cluster you want to switch : "))
			if s_no < matched_contexts_len:
				kswitch = all_names[s_no]
				sp.getstatusoutput(f"kubectl config use-context {kswitch}")
				print(f"kubectl is switched to {kswitch}")
			else:
				print("The selected context is out of scope, please check it...")
		else:
			try:
				kswitch = all_names[0]
				sp.getstatusoutput(f"kubectl config use-context {kswitch}")
				print(f"kubectl is switched to {kswitch}")
			except:
				print("Cluster with similar name does not exists \nUpdate your kubeconfig with ks update command")
		sp.call( "k1=${kubectl config current-context | awk -F'/' '{print $2}'}", executable='/bin/zsh')
		self.firstArg = kswitch

	def neat(self):
		data = sp.getoutput("cat - ")
		manifest = yaml.load(data, Loader=yaml.FullLoader)
		metadata_keys_remove = ["creationTimestamp", "generation", "resourceVersion", "uid" ]
		last_config = "kubectl.kubernetes.io/last-applied-configuration"
		metadata_keys=  manifest["metadata"].keys()
		if "annotations" in metadata_keys:
			if last_config in manifest["metadata"]["annotations"].keys():
				manifest["metadata"]["annotations"].pop(last_config)
		for key in metadata_keys_remove:
			if key in metadata_keys:
				manifest["metadata"].pop(key)
		status = "status"
		if status in manifest.keys():
			manifest.pop(status)
		data = yaml.dump(manifest)
		print(data)

	def decrypt(self, val):
		try:
			return base64.b64decode(val).decode("ascii")
		except:
			return "Issue while decrypting"




if __name__ == "__main__":

	parse = ag.ArgumentParser()
	parse.add_argument("firstArg",
		help="Name of the kubernetes cluster or any argument of the following \n list, update, current, sync, neat, decyrpt or d, and secret. Do ks clusterName to switch to a cluster.")
	parse.add_argument("secondArg", nargs='?',
		help="Sub command for the first argument", default="nil")
	parse.add_argument("-n", "--name", default="nil",
		help="Parser for first argument")
	parse.add_argument("-r", "--region", default="us-west-1",
		help="Indicates the aws region, by default it is us-west-1")
	parse.add_argument("-p", "--profile", default="nil",
		help="Indicates the aws profile")
	parse.add_argument("-f", "--filename", default="nil",
		help="yaml file for applying to secrets")
	
	args = parse.parse_args()
	firstArg = args.firstArg
	secondArg = args.secondArg
	name = args.name
	region = args.region
	profile = args.profile
	filename = args.filename


	kube_switcher = KubeSwitcher(firstArg=firstArg)


	if firstArg not in ["list", "update", "current", "neat", "decyrpt", "d"]:
		kube_switcher.switch_context()
	elif firstArg=="update":
		print(f"switching to new kubernetes cluster {firstArg}")
		sp.getstatusoutput(f"aws eks update-kubeconfig --name {name} --region {region} --profile {profile}")
	elif firstArg=="list":
		status = sp.getoutput(f"aws eks list-clusters --region {region} --profile {profile}")
		print(status)
	elif firstArg=="current":
		status  = sp.getoutput("kubectl config current-context")
		print(status)
		sp.call( "k1=${kubectl config current-context | awk -F'/' '{print $2}'}", executable='/bin/zsh')
	elif firstArg == "decyrpt" or firstArg == "d":
		data = sp.getoutput("cat - ")
		manifest = yaml.load(data, Loader=yaml.FullLoader)
		for i in manifest["data"].keys():
			print(f"{i}:", kube_switcher.decrypt(manifest["data"][i]))
	elif firstArg=="neat":
		kube_switcher.neat()
	else:
		print("Please select the update for updating the kube config")
