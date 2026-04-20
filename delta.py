import argparse
import logging
import subprocess
import typing

# creating logger 
logging.basicConfig(
    level=logging.INFO,
    format='%(levelname)s:%(filename)s:%(message)s'
)
dd_logger = logging.getLogger(__name__)

def delta_debugging(func, part:list, req:list, *args, **kwargs):
    """
    Delta debugging function (aka glorified binary search). Finds
    one-minimal interesting set for provided `func` and `part`. Interest
    function must be *monotonic*, *unambiguous*, and *consistent*.
    
    :param func: interest function that returns True or False and takes
        a set as a parameter (defines if partition set is interesting or
        not)
    :param part: partition set (a list underhood)
    :param req: requirement set (a list underhood)
    :param *args: extra arguments that func function takes
    :param **kwargs: extra keyword arguments that func function takes
    :return: return one-minimal interesting set
    """
    dd_logger.debug(f"dd({part}, required={req})")
    n = len(part)
    if n <= 1:
        return part
    
    # partitioning the initial partition set 
    l = list(part)
    part1 = part[:n//2]
    part2 = part[n//2:]

    # if the first partition with the required set is "interesting"
    if func(req + part1, *args, **kwargs):
        return delta_debugging(func, part1, req)
    # if the second partition with the required set is "interesting"
    elif func(req + part2, *args, **kwargs):
        return delta_debugging(func, part2, req)
    # both partitions are not "interesting"
    else:
        return delta_debugging(func, part1, part2 + req) + delta_debugging(func, part2, part1 + req)



# execute the delta debuggin only it is run as a main (therefore, the
# command to run and the arguments are provided)
if __name__ == "__main__":
    # creating arguement parser
    parser = argparse.ArgumentParser()
    parser.add_argument("set_size", type=int, help="size of set of interest")
    parser.add_argument("command", help="command to run")
    parser.add_argument("--verbose", action="store_true", help="show debug message")

    # parse the arguments
    args = parser.parse_args()

    if args.verbose:
        dd_logger.level = logging.DEBUG
    
    dd_logger.debug(f"Command is: {args.command}")

    # defining interest function
    def interest(part):
        """
        Check if the partition set is of interest. Execute the command
        provided in the python script argument 
        
        :param part: partition set 
        :return: True if partition is "interesting", otherwise False
        """
        
        # sorting part (needed for patching)
        part = sorted(part)

        dd_logger.debug(f"Executing `{args.command}" + f"{' '.join(map(str, part))}`")
        # executing command
        res = subprocess.run([args.command] + list(map(str, part)))

        dd_logger.debug(f"Return code: {res.returncode}")
        # checking status code to determine if it is executed correctly.
        if res.returncode == 1 and res.stderr is None:
            return True
        elif res.returncode == 0:
            return False
        else:
            print(res.returncode)
            print(res.stderr)
            raise Exception(res.stderr)

    # run the delta debuggin
    print(delta_debugging(interest, [i for i in range(args.set_size)], []))

