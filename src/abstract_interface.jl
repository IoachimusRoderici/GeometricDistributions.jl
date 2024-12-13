"""
Abstract type to represent distributions in a space of `N` dimensions.

`T` is the concrete container type used to represent points (`MVector{3, Float32}`, `Point2f`, etc.).
"""
abstract type GeometricDistribution{N, T} end

Base.eltype(::GeometricDistribution{N, T}) where {N, T} = T