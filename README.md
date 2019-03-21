# SRE exercise

## Problem

You just started working at this new company and they need a fleet of 4 servers to load-balance the traffic for the new site.
This new company wants to be able to use infrastructure as code methodology so you will have some restrictions:

- All code used needs to be in the repository
- You can use all the tools you'd like to create this infrastructure
- Each deployment needs to be immutable and there should be a versioned image of each version so a rollback is easily achievable
- You cannot do anything manually to create the first version or to replace for a new one except call the tools you use here
- GCP will be the cloud provider where you deploy this infrastructure
- The site should be in, at least, 2 regions to allow for regional failure
- The site to be served needs to have your name on it and a funny meme (make it extra funny)

---

## Layout

``` text
                                                        +---------+
                                                        |         |
                                                +------>+ Site    |
                                                |       |         |
                                                |       |         |
                                                |       +---------+
                                                |
                                                |       +---------+
                                                |       |         |
                                                +------>+ Site    |
                                                |       |         |
                                                |       |         |
+--------+                    +----------+      |       +---------+           Region A
|        |                    |          |      |
|        |                    | Load     +------+ +--------------------------------------------------+
|  User  +--------------------> Balancer |      |
|        |                    |          |      |       +---------+           Region B
|        |                    |          |      |       |         |
+--------+                    +----------+      |       |         |
                                                +------>+ Site    |
                                                |       |         |
                                                |       +---------+
                                                |
                                                |       +---------+
                                                |       |         |
                                                |       |         |
                                                +------>+ Site    |
                                                        |         |
                                                        +---------+
```

## Solutions

To submit a solution create a branch with you name on it and start commiting. :)