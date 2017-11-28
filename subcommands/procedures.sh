# requires functions.sh


#1st argument is the depth of the bomb tree
#2nd argument is the width of each tree node
#3rd argument is the name of the new repository
#4th argument is the file content of the bomb file
#5th argument is the commit message for the creation of the bomb
#6th argument is the name of the branch which will point to the commit
function proc_from_scratch() {
	expand_depth=5
	if [[ $1 =~ ^[0-9]+$ ]]
	then
		expand_depth="$1"
	fi
	expand_width=5
	if [[ $2 =~ ^[0-9]+$ ]]
	then
		expand_width="$2"
	fi
	reponame="$3"
	if [ -z "$reponame" ]
	then
		reponame="example"
	fi
	bombfilecontent="$4"
	if [ -z "$bombfilecontent" ]
	then
		bombfilecontent="one laugh"
	fi
	commitmessage="$5"
	if [ -z "$commitmessage" ]
	then
		commitmessage="million laughs"
	fi
	branchname="$6"
	if [ -z "$branchname" ]
	then
		branchname="master"
	fi
	
	
	init_repo "$reponame"
	
	treehash=$(create_content "$bombfilecontent" "$expand_width")
	for i in $(seq 2 "$expand_depth"); do
		treehash=$(expand_tree "$treehash" "$expand_width")
	done
	commithash=$(commit_tree "$treehash" "$commitmessage")
	
	create_branch "$commithash" "$branchname"
	checkout_commit "$branchname"
}


#1st argument is the depth of the bomb tree
#2nd argument is the width of each tree node
#3rd argument is the file content of the bomb file
#4th argument is the commit message for the creation of the bomb
#5th argument is the name of the branch which will point to the commit
function proc_put_in_branch() {
	expand_depth=5
	if [[ $1 =~ ^[0-9]+$ ]]
	then
		expand_depth="$1"
	fi
	expand_width=5
	if [[ $2 =~ ^[0-9]+$ ]]
	then
		expand_width="$2"
	fi
	bombfilecontent="$3"
	if [ -z "$bombfilecontent" ]
	then
		bombfilecontent="one laugh"
	fi
	commitmessage="$4"
	if [ -z "$commitmessage" ]
	then
		commitmessage="million laughs"
	fi
	branchname="$5"
	if [ -z "$branchname" ]
	then
		branchname="massive-improvement"
	fi
	
	
	last_commit=$(get_current_commit)
	clear_cache
	
	treehash=$(create_content "$bombfilecontent" "$expand_width")
	for i in $(seq 2 "$expand_depth"); do
		treehash=$(expand_tree "$treehash" "$expand_width")
	done
	commithash=$(commit_tree "$treehash" "$commitmessage" "$last_commit")
	
	create_branch "$commithash" "$branchname"
	git reset --hard
}


function proc_helptext() {
	echo ""
	echo "2 subcommands available:"
	echo ""
	echo "- gitbomb from-scratch"
	echo "  optional arguments:"
	echo "  1st argument is the depth of the bomb tree"
	echo "  2nd argument is the width of each tree node"
	echo "  3rd argument is the name of the new repository"
	echo "  4th argument is the file content of the bomb file"
	echo "  5th argument is the commit message for the creation of the bomb"
	echo "  6th argument is the name of the branch which will point to the commit"
	echo ""
	echo "- gitbomb put-in-branch"
	echo "  optional arguments:"
	echo "  1st argument is the depth of the bomb tree"
	echo "  2nd argument is the width of each tree node"
	echo "  3rd argument is the file content of the bomb file"
	echo "  4th argument is the commit message for the creation of the bomb"
	echo "  5th argument is the name of the branch which will point to the commit"
	echo ""
}
