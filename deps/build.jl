using PyCall
using Conda


if PyCall.conda
	Conda.add("pip")
    
    #Debug ode, where *is* pip?
    for (root, dirs, files) in walkdir(".")
      println("Files in $root")
      for file in files
          println(joinpath(root, file)) # path to files
      end
    end

	pip = joinpath(Conda.PYTHONDIR, "pip")
    run(`$pip install python-keystoneclient`)
	run(`$pip install python-swiftclient`)
else
	try
		pyimport("keystoneclient")
		pyimport("swiftclient")
	catch ee
		typeof(ee) <: PyCall.PyError || rethrow(ee)
		warn("""
Python Dependancies not installed
Please either:

 - Rebuild PyCall to use Conda, by running in the julia REPL:
    - `ENV["PYTHON"]=""; Pkg.build("PyCall"); Pkg.build("SwiftObjectStores")`
 - Or install the depencences yourself, eg by running pip
	- `pip install python-keystoneclient`
	- `pip install python-swiftclient`
	"""
		)
	end
end
