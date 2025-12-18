# Experimental PLN for Hyperon

## Description

This repository contains a number of experiments about Probabilistic
Logic Networs (PLN).  For a more production-ready version one may go
to the [PLN repository](https://github.com/trueagi-io/PLN) instead.

## Prerequisites

- [hyperon-experimental](https://github.com/trueagi-io/hyperon-experimental)
- [Maxima](https://maxima.sourceforge.io/)

## Usage

The port is approached from different angles which are

- Proofs as match queries
- Proofs as custom Atom structure
- Proofs as programs, and properties as dependent types

### PLN via Dependent Types

The most advanced approach for now is via dependent types and can be
found under

```
metta/dependent-types
```

The following examples can be run

```
metta metta/dependent-types/DeductionDTLTest.metta
metta metta/dependent-types/ImplicationDirectIntroductionDTLTest.metta
metta metta/dependent-types/DeductionImplicationDirectIntroductionDTLTest.metta
```

### Synthesizer

The dependent type approach relies on a generic program synthesizer
that can be found under

```
metta/synthesis
```

More information can be found in the `README.md` file under that
directory.

## Docker

A docker image containing a pre-installed version of Hyperon and PLN
is hosted on Docker Hub and can be run as follows:
```
docker run --rm -ti trueagi/pln
```

Additionally, a Dockerfile to build and update that image is present
under the root folder of that repository.  To build the image from
that local file, one may invoke the following command:
```
docker build -t trueagi/pln .
```

Or, using the URL of that Dockerfile:
```
docker build -t trueagi/pln https://raw.githubusercontent.com/trueagi-io/hyperon-pln/main/Dockerfile
```

## References

Below is a list of references to know more about PLN and its port to
Hyperon/MeTTa:

- [PLN Book](https://link.springer.com/book/10.1007/978-0-387-76872-4)
- [PLN for Procedural and Temporal Reasoning](https://www.researchgate.net/publication/370994045_Probabilistic_Logic_Networks_for_Temporal_and_Procedural_Reasoning)
- [Presentation of the synthesizer at AGI-23](https://odysee.com/@ngeiswei:d/AGI-23---Program-Synthesis-and-Chaining-with-MeTTa:3)
