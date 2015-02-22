##
##-- Matrix object creation ==> list of functions to handle matrix object
makeCacheMatrix <- function(x = matrix()) {
    m <- NULL
    # set function store matrix in cache
    set <- function(y) {
        x <<- y
        m <<- NULL
    }
    # get function return matrix
    get <- function() x
    # setsolve function store inv matrix
    setsolve <- function(solve) m <<- solve
    # getsolve function return inv matrix
    getsolve <- function() m
    list(set = set, get = get,
         setsolve = setsolve,
         getsolve = getsolve)
}
##
##-- Matrix Inversion return cache value if exists
cacheSolve <- function(x, ...) {
    #get inv matrix if inv in cache then return cache value
    m <- x$getsolve()
    if(!is.null(m)) {
        message("getting cached data")
        return(m)
    }
    #caculate inv matrix and strore it in cache
    data <- x$get()
    m <- solve(data, ...)
    x$setsolve(m)
    #return inv matrix
    m
}