(module
    (import "env" "buffer" (memory 1))
    (func $quadratic_roots (export "roots")
        (param $a f32) (param $b f32) (param $c f32)
        (local $discriminant f32)

        call $clear_memory

        local.get $a
        local.get $b
        local.get $c
        (local.tee $discriminant
            (
                f32.sub
                    (f32.mul (local.get $b) (local.get $b))
                    (f32.mul (f32.mul (f32.const 4) (local.get $a)) (local.get $c))
            )
        )
        
        ;; check if discriminant is l.t. 0
        (
            f32.lt
            (f32.const 0)
        )

        local.get $discriminant

        call $get_roots
    )

    (func $clear_memory
        (f32.store (i32.const 0) (f32.const 0))
        (f32.store (i32.const 4) (f32.const 0))
        (f32.store (i32.const 8) (f32.const 0))
        (f32.store (i32.const 12) (f32.const 0))
    )

    (func $get_roots (param $a f32) (param $b f32) (param $c f32) (param $is_complex i32) (param $discriminant f32)
        (local $addr_a i32)
        (local $addr_b i32)
        (local $divisor f32) ;; 2a
        (local $u f32) ;; -b/2a

        (local.tee $addr_a (i32.mul (local.get $is_complex) (i32.const 4)))
        (local.set $addr_b (i32.add (i32.const 8)))

        (f32.mul (f32.const -1) (local.get $b))
        (local.tee $divisor (f32.mul (f32.const 2) (local.get $a)))

        (local.set $u (f32.div))
        (f32.store (i32.const 0) (local.get $u))
        (f32.store (i32.const 8) (local.get $u))

        (f32.store 
            (local.get $addr_a) 
            (f32.add
                (f32.load (local.get $addr_a))
                (f32.div
                    (f32.sqrt 
                        (f32.abs
                            (local.get $discriminant)
                        )
                    )
                    (local.get $divisor)
                )
            )
        )

        (f32.store 
            (local.get $addr_b)
            (f32.sub
                (f32.load (local.get $addr_b))
                (f32.div
                    (f32.sqrt 
                        (f32.abs
                            (local.get $discriminant)
                        )
                    )
                    (local.get $divisor)
                )
            )
        )
    )
)