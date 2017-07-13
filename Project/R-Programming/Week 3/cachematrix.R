## Write a short comment describing this function

makeCacheMatrix <- function(x = matrix()) {
  
  inverse <- NULL;
  set <- function(y){
    x <<- y;
    inverse <<- NULL;
  }
  get <- function() x;
  setinv <- function(inv) inverse <<- inv;
  getinv <- function() return(inverse);
  return(list(set=set, get=get, setinv=setinv, getinv=getinv));
}


## Write a short comment describing this function

cacheSolve <- function(x, ...) {
  ## Return a matrix that is the inverse of 'x'
  ## Return a matrix that is the inverse of 'x'
  
  inverse <- x$getinv();
  if(!is.null(inverse)){
    message("getting cached matrix");
    return(inverse);
  }
  data <- x$get();
  inverse <- solve(data);
  x$setinv(inverse);
  return(inverse);
}

## Sample:
##
## x = rbind(c(1,2),c(3,4));
## inverse=makeCacheMatrix(x);
## inverse$get();
## cacheSolve(inverse); ## No Cache
## cacheSolve(inverse); ## from second run
