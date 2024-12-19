@testset "No Allocations" begin
    mutable3d = MVector(1,2,3.)
    
    @test @allocations(rand(UniformDirection(Point2f))) == 0
    @test @allocations(rand(UniformDirection(SVector{10, Float16}))) == 0
    @test @allocations(rand!(mutable3d, UniformDirection())) == 0

    @test @allocations(rand(UniformInsideUnitSphere(Point2f))) == 0
    @test @allocations(rand(UniformInsideUnitSphere(SVector{10, Float16}))) == 0
    @test @allocations(rand!(mutable3d, UniformInsideUnitSphere())) == 0
end