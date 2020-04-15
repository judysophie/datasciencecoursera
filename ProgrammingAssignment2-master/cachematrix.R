# GENERAL: The deep assignemnt arrow (or superassignment operator) <<- DOES NOT
# create a variable in the current environments, but modifies an existing variable 
# found by "walking up" the parent environments OR creates one on the global environment. 
# "<<- rebinds an existing name in a parent of the current environment."
# (all quoted from: http://adv-r.had.co.nz/Environments.html).


# This function takes a matrix, and provides for functions to set and retrieve
# the value  of this matrix, and to set and retrieve the value of the inverse
# matrix.
# The function should be called once for a matrix. Once the matrix (x) changes, the
# inverse will be deleted.

makeCacheMatrix <- function(x = matrix()) {
    inv <- NULL
    # the set() function will take x as y and then set x to the passed
    # in value in the global environment!
    # Additionally, cache is cleared
    set <- function(y){
        x <<- y
        inv <- NULL
    } 
    get <- function() x
    setinv <- function(inv) inv <<- solve(x)
    getinv <- function() inv
    list(set = set, get = get, setinv = setinv, getinv = getinv)
}

# This function takes a list as input, the return values of makeCacheMatrix()
# (functions and input).
# It will acess the input value for getinv (the inverse matrix). 
# If the inverse has not been computed (==NULL), it will compute the inverse and 
# return it. Otherwise, it will return it from the cache.

cacheSolve <- function(x, ...) {
    inv <- x$getinv()
    if (!is.null(inv)) {
        print("Retrieving inversed matrix from cache")
        return(inv)
    }
    data <- x$get()
    inv <- solve(data, ...)
    #set the "setinv" in list of makeCacheMatrix
    x$setinv(inv)
    inv
}
