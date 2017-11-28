#1st argument is the repository name
function init_repo() {
	repo_name="$1"
	if [ -z "$repo_name" ] 
	then
		repo_name="repository"
	fi
	
	git init "$1"
	cd "$1"
}

#no args, no return
function clear_cache() {
	git reset --hard > /dev/null
	git rm -r * > /dev/null 2> /dev/null
}

#1st argument is the file content
#2nd argument is the width of the created tree
#returns hashcode of a tree containing just one file
function create_content() {
	file_content="$1"
	if [ -z "$file_content" ] 
	then
		file_content="one laugh"
	fi
	expand_width="$2"
	if [ -z "$expand_width" ] 
	then
		expand_width=10
	fi
	
	filehash=$(echo "$file_content" | git hash-object -w --stdin)
	treestring=
	for i in $(seq 1 "$expand_width"); do
		if [ ! -z "$treestring" ] 
		then
			treestring+="\n"
		fi
		treestring+="100644 blob $filehash\tf$i"
	done
	echo -e "$treestring" | git mktree
}

#1st argument is the hashcode of the child tree
#2nd argument is the width of the new tree
#returns hashcode of a tree $2 times as big as tree $1
function expand_tree() {
	subhash="$1"
	if [ -z "$subhash" ] 
	then
		exit 1
	fi
	expand_width="$2"
	if [ -z "$expand_width" ] 
	then
		expand_width=10
	fi

	treestring=
	for i in $(seq 1 "$expand_width"); do
		if [ ! -z "$treestring" ] 
		then
			treestring+="\n"
		fi
		treestring+="040000 tree $subhash\td$i"
	done
	
	echo -e "$treestring" | git mktree
}

#1st argument is a tree hashcode
#2nd argument is a commit message
#3rd argument is the hashcode of the previous commit
#returns hashcode of the 
function commit_tree() {
	treehash="$1"
	if [ -z "$treehash" ] 
	then
		exit 1
	fi
	commitmessage="$2"
	if [ -z "$commitmessage" ] 
	then
		commitmessage="gitbomb"
	fi
	parenthash="$3"
	if [ -z "$parenthash" ]
	then
		echo "$commitmessage" | git commit-tree "$treehash"
	else
		echo "$commitmessage" | git commit-tree -p "$parenthash" "$treehash"
	fi
}

#1st argument is a commit hashcode
#2nd argument is a branch name
function create_branch() {
	commithash="$1"
	if [ -z "$commithash" ] 
	then
		exit 1
	fi
	branchname="$2"
	if [ -z "$branchname" ] 
	then
		branchname="master"
	fi
	git branch -f "$branchname" "$commithash"
}

#1st argument is a commit hashcode
function update_branch() {
	commithash="$1"
	if [ -z "$commithash" ] 
	then
		exit 1
	fi
	git reset --hard "$commithash"
}

#1st argument is a commit hashcode or branchname
function checkout_commit() {
	commit="$1"
	if [ -z "$commit" ] 
	then
		commit="HEAD"
	fi
	git checkout -f "$commit"
}

#returns name of current branch
function get_current_branch() {
	git symbolic-ref HEAD
}

#returns hash of current commit
function get_current_commit() {
	current_branch=$(get_current_branch)
	git show-ref --hash "$current_branch"
}


