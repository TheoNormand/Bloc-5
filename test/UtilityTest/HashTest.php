<?php

use PHPUnit\Framework\TestCase;
use App\Utility\Hash;

final class HashTest extends TestCase
{
    /** @test  */
    public function generateTest()
    {
        $HashTest = Hash::generate("Test");

        $this->assertGreaterThan(0, strlen($HashTest));



    }

    /** @test */
    public function generateSaltTest()
    {
        $HashTest = Hash::generateSalt("Test");


    }

}
