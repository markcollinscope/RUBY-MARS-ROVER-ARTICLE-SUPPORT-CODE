# Mars Rover - An Example Ruby Program
This is a small - but not trivial - Ruby program I wrote as part of a learning exercise with Ruby. It implements the specification given below.

It also is intended as a worked example to support the architectural rules outlined in the following article:
https://www.infoq.com/articles/arm-enterprise-applications/

which proposes five 'layers' or 'strata' within which modules should be placed - depending on what they do and the nature of the code 
they contain. The strata are 'interface', 'application', 'domain', 'infrastructure' and 'platform' - see the article for a full description.

If you want to understand the modular structure used here - you need to read that!

## Specification
### Overview
A squad of robotic rovers are to be landed by NASA on a plateau on Mars.
This plateau, which is curiously rectangular, must be navigated by the
rovers so that their on-board cameras can get a complete view of the
surrounding terrain to send back to Earth.

* Rover's position and location is represented by (X,Y,D)
	- X,Y are normal co-ordinates
	- D is one of N (North), E (East), S (South), W (West) - the direction the Rover is facing.
	- e.g 0,0, N - Bottom left facing North.
	_ Can't go below 0,0

* To control the Rover Nasa sends a simple string of letters. 
* These are:
	- L - Turn left (90 degrees, so direction N becomes W)
	- R - ditto but right
	- M - move forward place (e.g. if at 2,3,N will end up at 2,4 N)


(The square directly North from (x, y) is (x, y+1))

### Input (read from file)
* first line contains the upper right limit of the plateau 
	- e.g. 5,7 means X goes 0..5 inclusive, Y: 0..7 inclusive
	- lower-left coordinates are assumed to be 0,0.

* the rest of the input applies in 2 line chunks to each successive Rover
	- X,Y - the start position of Rover "N"
	- then string: MMMLLLRRRRMMMLLL as described above - commands the Rover must follow.


* Each rover will be finished sequentially, second rover won't start to move until the first finished.
* For testing, the input should be put in a file and passed to the program as a command line arg.


### Output (to stdout)
The output for each rover should be its final co-ordinates and heading (e.g. 5,5,E)

### Errors 
* an error should be raised if a rover goes outside the grid boundary (0,0) -> (n,n)
* an error should be raised if two rovers collide whilst one is moving (intermediate positions as well)
* there should be some basic reporting of syntax errors in the control file


### Example Input/Output

Test Input:
```
5 5
1 2 N
LMLMLMLMM
3 3 E
MMRMMRMRRM
```

Expected Output:
```
1 3 N
5 1 E
```

## Discussion of Solution

### To Run The Program (assuming you have ruby set up)
$ ruby main.rb manualtestfile.txt - will give expected results.

### To Run the full unit test suite
$ ruby ts_full.rb

### Input Data Files
* manualtestfile.txt - contains the example in the specification - it is parsed by the app.
* other ***.txt*** files contain data used in unit testing. Don't change them, The parser unit tests rely on them as they have to parse 
data in files during testing.

### Source Code Files

***Dependencies:***
main -> parser -> grid -> rover -> pair

Dependencies are acyclic and all 'point downwards' (see article).

The source is fit into four main sections:
* pair.rb - utilities for adding co-ordinates, etc. a pair { x, y } - architecturally this is 'infrastructure' (see article).
* rover.rb - Rover object - maintains internal state and direction information - architecturally this is 'domain' 
* grid.rb - Grid object - size - and also error detection (exceptions) for "out of bounds" and "collision" errors - architecturally this could be considered 'application' or 'domain' - this is a small example, so the distinction isn't as clear as it could be.
* parser.rb - deals with parsing (syntax errors, etc.) the input file and calling 'grid' to do stuff - architecturally this is 'interface'.

main.rb deals with commandline args and tidying up exception messages to make them user-friendly (-ish!)

Note 1: the grid module provides a facade to the "core business logic" of the application (so it is 'application strata). 
In other words it provides a set of services which UIs or Parsers can use to do stuff. Very SOA! 
This is beneficial for core functional testing.

Note 2: the parser module is an example of 'interface' strata code that is not classic user interface (dialog boxes, buttons etc). 
Nevertheless it uses exactly the same 'application' strata code (grid in this case) to get the core application to do something.

### Unit Test Files
* each of the four main sections has its own unit test file - which can be run in isolation - ts_XXXX.rb
* tests are quite extensive
* all pulled together into "ts_full.rb" for full system test.

### A Note On Modules:
I've only used "module" to group those sections which have multiple tightly inter-related classes:
* grid - main class + exceptions
* parser - main class + exceptions

the rest I've just left as classes (though they could be turned into modules too)

### Improvements & Other Musings

There are two major refactorings that would improve the design of this application - they are both related to the use of Directions.

1. Refactor the code related to Directions in the Rover (:north, :south, etc.) and put it into a Directions class - this would include the logic on how to turn. The Directions class would contain a single state variable (@currentDirection) to store the current direction (in much the same way as Pair stores x,y co-ordinates). Rover would then contain an instance of Direction (@direction). This improvement would add clarity to the code by seperating the concerns of Rover and Direction. Note: it is possible implement this refactoring without changing the public interface to Rover.

2. Refactor the logic in Main and Parser related to input/output translation of Directions (e.g. 'N' -> :north)... Put both the Hashes DIRECTIOSN and OUTPUTDIRECTIONS into a single class called something like DirectionsIOMapping - this would pull all the relevent IO mapping logic into one place, and thus ease later modification.

Note: It might be tempting to merge DirectionsIOMapping and Directions into one class. The downside of this is that DirectionsIOMapping is a concern of Interface (to the outside world, much like a UI, but text based in this case) and is much more to change that the core Directions logic. There may also be more than IO method - e.g. a GUI or web interface. It wouldn't be appropriate to put this code into Directions, and so by the same logic neither should the DirectionsIOMapping logic go in it.

Some other observations:

3. Change the use of ":north" and use constants instead - e.g. Directions::NORTH. Mistypings like "Directions::NRTH" would be picked up by the intepreter, whereas mistyping ":nrth" would lead to a less obvious run-time error.

Finally, the code uses camelCase convention. This is a personal preference, however some prefer the (not) camel_case convention. Ultimately this is a matter for project standards - either could be used.
