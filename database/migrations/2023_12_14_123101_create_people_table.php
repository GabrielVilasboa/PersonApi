<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('people', function (Blueprint $table) {
            $table->id();
            $table->string('name');
            $table->string('last_name');
            $table->string('email');
            $table->string('phone')->nullable(true);
            $table->string('weight')->nullable(true);
            $table->string('height')->nullable(true);
            $table->integer('age');
            $table->string('occupation')->nullable(true);
            $table->date('date_of_birth')->nullable(true);
            $table->string('document')->nullable(true);
            $table->string('nationality')->nullable(true);
            $table->string('adreass')->nullable(true);
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('people');
    }
};
