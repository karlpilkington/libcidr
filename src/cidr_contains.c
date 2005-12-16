/*
 * cidr_contains() - Is one block entirely contained in another?
 */

#include <stdio.h> /* For NULL */

#include <libcidr.h>

int
cidr_contains(const CIDR *big, const CIDR *little)
{
	int i, oct, bit;
	int pflen;

	/* Sanity */
	if(big==NULL || little==NULL)
		return(-1);

	/* First off, they better be the same type */
	if(big->proto != little->proto)
		return(-1);
	
	/* We better understand the protocol, too */
	if(big->proto!=CIDR_IPV4 && big->proto!=CIDR_IPV6)
		return(-1);
	
	/*
	 * little better be SMALL enough to fit in big.  Note: The prefix
	 * lengths CAN be the same, and little could still 'fit' in big if
	 * the network bits are all the same.  No need to special-case it, as
	 * the normal tests below will DTRT.  Save big's pflen for the test
	 * loop.
	 */
	if(cidr_get_pflen(little) < (pflen = cidr_get_pflen(big)))
		return(-1);
	
	/*
	 * Now let's compare.  Note that for IPv4 addresses, the first 12
	 * octets are irrelevant.  We take care throughout to keep them
	 * zero'd out, so we don't _need_ to explicitly ignore them.  But,
	 * it's wasteful; it quadrules the amount of work needed to be done
	 * to compare to v4 blocks, and this function may be useful in fairly
	 * performance-sensitive parts of the application.  Sure, an extra 12
	 * uint8_t compares better not be the make-or-break perforamnce point
	 * for anything real, but why make it harder unnecessarily?
	 */
	if(big->proto==CIDR_IPV4)
	{
		i = 96;
		pflen += 96;
	}
	else if(big->proto==CIDR_IPV6)
		i = 0;
	else
		return(-1); /* Shouldn't happen */
	
	/* Start comparing */
	for( /* i */ ; i < pflen ; i++ )
	{
		/* For convenience, set temp. vars to the octet/bit */
		oct = i/8;
		bit = 7-(i%8);

		if((big->addr[oct] & (1<<bit)) != (little->addr[oct] & (1<<bit)))
			return(-1);
	}

	/* If we get here, all their network bits are the same */
	return(0);
}
