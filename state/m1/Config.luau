-- Shared prototype tuning. No economy, HP, deadlines, or strikes in M1.
return {
    Reach = 8, HandoffSeconds = 5, RecoverCooldown = 10, ResultSeconds = 5,
    CarrySpeed = 13.6, CarryOffset = Vector3.new(0, 0, -4),
    Responsiveness = 22, MaxVelocity = 24, ForceGravityMultiplier = 6,
    FollowError = 10, FollowErrorSeconds = 1.5,
    BoundsMin = Vector3.new(-45, -12, -780), BoundsMax = Vector3.new(120, 100, 30),
    StaminaCapacity=100, Endurance={45,25,20,18}, Regeneration=10,
    ReceiveMinimum=10, LowStamina=25, RunSpeed=1.25, RunDrain=1.5,
    ChargeSeconds=1, ThrowMin=55, ThrowMax=95, MinElevation=15, MaxElevation=60,
    CatchTargetRange=16, CatchAngle=15, CatchSeconds=0.5, CatchRadius=6,
    CheckpointCount=6,
}
